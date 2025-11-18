#!/bin/bash

#####################################
# EC2 User Data Script Refactored
# Installs Apache and creates a 
# dynamic system monitoring page
#####################################

# 1. Update system and install necessary packages
yum update -y
yum install -y httpd net-tools # net-tools for 'ip route' command
systemctl start httpd
systemctl enable httpd

# 2. Install EC2 Metadata package for Amazon Linux 2023 compatibility
# ec2-metadata is often not installed by default or requires specific packages/paths.
# On AL2023, instance metadata can typically be accessed via the instance metadata service (IMDS)
# or the 'ec2-metadata' command if the 'cloud-utils-ec2-metadata' package is installed.
# We'll stick to the existing ec2-metadata calls, assuming it's available or linked from the standard path.
# If these commands fail, manual testing or installing 'cloud-utils-ec2-metadata' may be required.

# 3. Capture Dynamic System Data into Variables
HOST_NAME=$(hostname -f)
INST_ID=$(ec2-metadata --instance-id | cut -d ' ' -f 2)
INST_TYPE=$(ec2-metadata --instance-type | cut -d ' ' -f 2)
AZ_ZONE=$(ec2-metadata --availability-zone | cut -d ' ' -f 2)
AMI_ID=$(ec2-metadata --ami-id | cut -d ' ' -f 2)
REGION=$(echo $AZ_ZONE | sed 's/[a-z]$//')

MEM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
MEM_AVAILABLE=$(free -h | awk '/^Mem:/ {print $7}')
MEM_USED=$(free -h | awk '/^Mem:/ {print $3}')
MEM_USAGE_PCT=$(free | awk '/^Mem:/ {printf "%.1f%%", $3/$2 * 100}')
MEM_USAGE_STYLE=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2 * 100}')

SWAP_TOTAL=$(free -h | awk '/^Swap:/ {print $2}')
SWAP_USAGE_PCT=$(free | awk '/^Swap:/ {if ($2 > 0) printf "%.1f%%", $3/$2 * 100; else print "0%"}')
SWAP_USAGE_STYLE=$(free | awk '/^Swap:/ {if ($2 > 0) printf "%.0f", $3/$2 * 100; else print "0"}')

DISK_FS=$(df -h / | awk 'NR==2 {print $1}')
DISK_SIZE=$(df -h / | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_AVAIL=$(df -h / | awk 'NR==2 {print $4}')
DISK_USAGE_PCT=$(df -h / | awk 'NR==2 {print $5}')
DISK_TYPE=$(df -T / | awk 'NR==2 {print $2}')

DISK_USAGE_RAW=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
DISK_COLOR=""
if [ $DISK_USAGE_RAW -gt 80 ]; then
    DISK_COLOR="danger"
elif [ $DISK_USAGE_RAW -gt 60 ]; then
    DISK_COLOR="warning"
fi

CPU_MODEL=$(lscpu | grep "Model name" | cut -d ':' -f 2 | xargs)
CPU_CORES=$(nproc)
ARCH=$(uname -m)
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | xargs)
UPTIME=$(uptime -p | sed 's/up //')
PROC_COUNT=$(ps aux | wc -l)

IP_PRIVATE=$(ec2-metadata --local-ipv4 | cut -d ' ' -f 2)
IP_PUBLIC=$(ec2-metadata --public-ipv4 | cut -d ' ' -f 2)
VPC_ID=$(ec2-metadata --vpc-id | cut -d ' ' -f 2)
SUBNET_ID=$(ec2-metadata --subnet-id | cut -d ' ' -f 2)
MAC_ADDR=$(ec2-metadata --mac | cut -d ' ' -f 2)
DEFAULT_GW=$(ip route | grep default | awk '{print $3}')
DNS_SERVER=$(grep nameserver /etc/resolv.conf | awk '{print $2}' | head -1)
SEC_GROUPS=$(ec2-metadata --security-groups | cut -d ' ' -f 2 | head -1)

SERVER_TIME=$(date '+%Y-%m-%d %H:%M:%S %Z')


# 4. Write HTML content, substituting variables
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Server Monitor Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }

        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
        }

        .status-badge {
            display: inline-block;
            background: rgba(16, 185, 129, 0.2);
            color: #10b981;
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 600;
            border: 2px solid #10b981;
        }

        .content {
            padding: 2rem;
        }

        .section {
            margin-bottom: 3rem;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 3px solid #f1f5f9;
        }

        .section-header h2 {
            font-size: 1.5rem;
            color: #1e293b;
        }

        .badge {
            background: #667eea;
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
        }

        .card {
            background: #f8fafc;
            border-radius: 12px;
            padding: 1.5rem;
            border-left: 4px solid #667eea;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .card.network {
            border-left-color: #10b981;
        }

        .card.resource {
            border-left-color: #f59e0b;
        }

        .card.cpu {
            border-left-color: #8b5cf6;
        }

        .card-title {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #64748b;
            margin-bottom: 0.75rem;
            font-weight: 600;
        }

        .card-value {
            font-size: 1.125rem;
            font-weight: 700;
            color: #1e293b;
            font-family: 'Courier New', monospace;
            word-break: break-all;
            background: white;
            padding: 0.5rem 0.75rem;
            border-radius: 6px;
        }

        .progress-container {
            margin-top: 0.75rem;
        }

        .progress-bar {
            width: 100%;
            height: 24px;
            background: #e2e8f0;
            border-radius: 12px;
            overflow: hidden;
            position: relative;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #10b981, #059669);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.75rem;
            font-weight: 700;
            transition: width 0.5s ease;
            position: relative;
        }

        .progress-fill.warning {
            background: linear-gradient(90deg, #f59e0b, #d97706);
        }

        .progress-fill.danger {
            background: linear-gradient(90deg, #ef4444, #dc2626);
        }

        .footer {
            background: #f8fafc;
            padding: 2rem;
            text-align: center;
            color: #64748b;
            border-top: 1px solid #e2e8f0;
        }

        .footer p {
            margin: 0.5rem 0;
        }

        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }

            .header h1 {
                font-size: 1.75rem;
            }

            .grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 Server Monitor Dashboard</h1>
            <div class="status-badge">✓ System Online</div>
        </div>

        <div class="content">
            <div class="section">
                <div class="section-header">
                    <h2>📊 Instance Information</h2>
                    <span class="badge">AWS EC2</span>
                </div>
                <div class="grid">
                    <div class="card">
                        <div class="card-title">Hostname</div>
                        <div class="card-value">${HOST_NAME}</div>
                    </div>
                    <div class="card">
                        <div class="card-title">Instance ID</div>
                        <div class="card-value">${INST_ID}</div>
                    </div>
                    <div class="card">
                        <div class="card-title">Instance Type</div>
                        <div class="card-value">${INST_TYPE}</div>
                    </div>
                    <div class="card">
                        <div class="card-title">Availability Zone</div>
                        <div class="card-value">${AZ_ZONE}</div>
                    </div>
                    <div class="card">
                        <div class="card-title">AMI ID</div>
                        <div class="card-value">${AMI_ID}</div>
                    </div>
                    <div class="card">
                        <div class="card-title">Region</div>
                        <div class="card-value">${REGION}</div>
                    </div>
                </div>
            </div>

            <div class="section">
                <div class="section-header">
                    <h2>💾 Memory & Swap</h2>
                    <span class="badge">Resources</span>
                </div>
                <div class="grid">
                    <div class="card resource">
                        <div class="card-title">Total Memory</div>
                        <div class="card-value">${MEM_TOTAL}</div>
                    </div>
                    <div class="card resource">
                        <div class="card-title">Available Memory</div>
                        <div class="card-value">${MEM_AVAILABLE}</div>
                    </div>
                    <div class="card resource">
                        <div class="card-title">Used Memory</div>
                        <div class="card-value">${MEM_USED}</div>
                    </div>
                    <div class="card resource">
                        <div class="card-title">Memory Usage</div>
                        <div class="card-value">${MEM_USAGE_PCT}</div>
                        <div class="progress-container">
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: ${MEM_USAGE_STYLE}%">
                                    ${MEM_USAGE_PCT}
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card resource">
                        <div class="card-title">Total Swap</div>
                        <div class="card-value">${SWAP_TOTAL}</div>
                    </div>
                    <div class="card resource">
                        <div class="card-title">Swap Usage</div>
                        <div class="card-value">${SWAP_USAGE_PCT}</div>
                        <div class="progress-container">
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: ${SWAP_USAGE_STYLE}%">
                                    ${SWAP_USAGE_PCT}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="section">
                <div class="section-header">
                    <h2>💿 Storage</h2>
                    <span class="badge">Disk</span>
                </div>
                <div class="grid">
                    <div class="card resource">
                        <div class="card-title">Filesystem</div>
                        <div class="card-value">${DISK_FS}</div>
                    </div>
                    <div class="card resource">
                        <div class="card-title">Total Size</div>
                        <div class="card-value">${DISK_SIZE}</div>
                    </div>
                    <div class="card resource">
                        <div class="card-title">Used Space</div>
                        <div class="card-value">${DISK_USED}</div>
                    </div>
                    <div class="card resource">
                        <div class="card-title">Available Space</div>
                        <div class="card-value">${DISK_AVAIL}</div>
                    </div>
                    <div class="card resource">
                        <div class="card-title">Disk Usage</div>
                        <div class="card-value">${DISK_USAGE_PCT}</div>
                        <div class="progress-container">
                            <div class="progress-bar">
                                <div class="progress-fill ${DISK_COLOR}" style="width: ${DISK_USAGE_PCT}">
                                    ${DISK_USAGE_PCT}
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card resource">
                        <div class="card-title">Filesystem Type</div>
                        <div class="card-value">${DISK_TYPE}</div>
                    </div>
                </div>
            </div>

            <div class="section">
                <div class="section-header">
                    <h2>⚙️ CPU & Performance</h2>
                    <span class="badge">Processor</span>
                </div>
                <div class="grid">
                    <div class="card cpu">
                        <div class="card-title">CPU Model</div>
                        <div class="card-value">${CPU_MODEL}</div>
                    </div>
                    <div class="card cpu">
                        <div class="card-title">vCPU Cores</div>
                        <div class="card-value">${CPU_CORES} cores</div>
                    </div>
                    <div class="card cpu">
                        <div class="card-title">Architecture</div>
                        <div class="card-value">${ARCH}</div>
                    </div>
                    <div class="card cpu">
                        <div class="card-title">Load Average</div>
                        <div class="card-value">${LOAD_AVG}</div>
                    </div>
                    <div class="card cpu">
                        <div class="card-title">System Uptime</div>
                        <div class="card-value">${UPTIME}</div>
                    </div>
                    <div class="card cpu">
                        <div class="card-title">Running Processes</div>
                        <div class="card-value">${PROC_COUNT} processes</div>
                    </div>
                </div>
            </div>

            <div class="section">
                <div class="section-header">
                    <h2>🌐 Network Configuration</h2>
                    <span class="badge">VPC</span>
                </div>
                <div class="grid">
                    <div class="card network">
                        <div class="card-title">Private IPv4</div>
                        <div class="card-value">${IP_PRIVATE}</div>
                    </div>
                    <div class="card network">
                        <div class="card-title">Public IPv4</div>
                        <div class="card-value">${IP_PUBLIC}</div>
                    </div>
                    <div class="card network">
                        <div class="card-title">VPC ID</div>
                        <div class="card-value">${VPC_ID}</div>
                    </div>
                    <div class="card network">
                        <div class="card-title">Subnet ID</div>
                        <div class="card-value">${SUBNET_ID}</div>
                    </div>
                    <div class="card network">
                        <div class="card-title">MAC Address</div>
                        <div class="card-value">${MAC_ADDR}</div>
                    </div>
                    <div class="card network">
                        <div class="card-title">Default Gateway</div>
                        <div class="card-value">${DEFAULT_GW}</div>
                    </div>
                    <div class="card network">
                        <div class="card-title">DNS Server</div>
                        <div class="card-value">${DNS_SERVER}</div>
                    </div>
                    <div class="card network">
                        <div class="card-title">Security Group</div>
                        <div class="card-value">${SEC_GROUPS}</div>
                    </div>
                </div>
            </div>

            <div class="section">
                <div class="section-header">
                    <h2>📡 Connection Details</h2>
                    <span class="badge">Live</span>
                </div>
                <div class="grid">
                    <div class="card network">
                        <div class="card-title">Your IP Address</div>
                        <div class="card-value" id="client-ip">Loading...</div>
                    </div>
                    <div class="card network">
                        <div class="card-title">Protocol</div>
                        <div class="card-value">HTTP/1.1</div>
                    </div>
                    <div class="card network">
                        <div class="card-title">Server Port</div>
                        <div class="card-value">80</div>
                    </div>
                    <div class="card network">
                        <div class="card-title">Server Time</div>
                        <div class="card-value">${SERVER_TIME}</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="footer">
            <p><strong>🏗️ Infrastructure as Code</strong></p>
            <p>Deployed via Terraform | AWS Application Load Balancer</p>
            <p>⚡ Powered by Amazon Linux 2023 + Apache HTTP Server</p>
        </div>
    </div>

    <script>
        // Fetch visitor's public IP address
        fetch('https://api.ipify.org?format=json')
            .then(response => response.json())
            .then(data => {
                document.getElementById('client-ip').textContent = data.ip;
            })
            .catch(error => {
                document.getElementById('client-ip').textContent = 'Unable to detect';
                console.error('Error fetching IP:', error);
            });
    </script>
</body>
</html>
EOF

# Log completion
echo "User data script completed successfully" >> /var/log/user-data.log
date >> /var/log/user-data.log
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Create detailed index page - Note: Use EOF without quotes to allow variable expansion
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>No-Cost App Server</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 1200px;
            margin: 50px auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #333;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        h1 {
            color: #667eea;
            border-bottom: 3px solid #667eea;
            padding-bottom: 10px;
        }
        h2 {
            color: #764ba2;
            margin-top: 40px;
            margin-bottom: 20px;
            font-size: 24px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        .info-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        .info-card h3 {
            margin-top: 0;
            color: #667eea;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .info-card p {
            margin: 10px 0 0 0;
            font-size: 16px;
            color: #333;
            font-weight: 600;
            word-break: break-all;
        }
        .status {
            display: inline-block;
            padding: 8px 16px;
            background: #10b981;
            color: white;
            border-radius: 20px;
            font-weight: 600;
            margin: 20px 0;
        }
        .footer {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #e5e7eb;
            text-align: center;
            color: #6b7280;
            font-size: 14px;
        }
        code {
            background: #f3f4f6;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: monospace;
            font-size: 14px;
        }
        .network-card {
            border-left-color: #10b981;
        }
        .resource-card {
            border-left-color: #f59e0b;
        }
        .section-badge {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 10px;
        }
        .progress-bar {
            width: 100%;
            height: 20px;
            background: #e5e7eb;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 10px;
        }
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #10b981, #059669);
            transition: width 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
            font-weight: 600;
        }
        .progress-fill.warning {
            background: linear-gradient(90deg, #f59e0b, #d97706);
        }
        .progress-fill.danger {
            background: linear-gradient(90deg, #ef4444, #dc2626);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 No-Cost App Server</h1>
        <div class="status">✓ Server Running</div>
        
        <h2>📊 Instance Information</h2>
        <div class="info-grid">
            <div class="info-card">
                <h3>Hostname</h3>
                <p><code>$(hostname -f)</code></p>
            </div>
            
            <div class="info-card">
                <h3>Instance ID</h3>
                <p><code>$(ec2-metadata --instance-id | cut -d ' ' -f 2)</code></p>
            </div>
            
            <div class="info-card">
                <h3>Instance Type</h3>
                <p><code>$(ec2-metadata --instance-type | cut -d ' ' -f 2)</code></p>
            </div>
            
            <div class="info-card">
                <h3>Availability Zone</h3>
                <p><code>$(ec2-metadata --availability-zone | cut -d ' ' -f 2)</code></p>
            </div>
            
            <div class="info-card">
                <h3>AMI ID</h3>
                <p><code>$(ec2-metadata --ami-id | cut -d ' ' -f 2)</code></p>
            </div>
            
            <div class="info-card">
                <h3>Region</h3>
                <p><code>$(ec2-metadata --availability-zone | cut -d ' ' -f 2 | sed 's/[a-z]$//')</code></p>
            </div>
        </div>
        
        <h2>💾 System Resources <span class="section-badge">Memory & Storage</span></h2>
        <div class="info-grid">
            <div class="info-card resource-card">
                <h3>Total Memory</h3>
                <p><code>$(free -h | awk '/^Mem:/ {print \$2}')</code></p>
            </div>
            
            <div class="info-card resource-card">
                <h3>Available Memory</h3>
                <p><code>$(free -h | awk '/^Mem:/ {print \$7}')</code></p>
            </div>
            
            <div class="info-card resource-card">
                <h3>Used Memory</h3>
                <p><code>$(free -h | awk '/^Mem:/ {print \$3}')</code></p>
            </div>
            
            <div class="info-card resource-card">
                <h3>Memory Usage %</h3>
                <p><code>$(free | awk '/^Mem:/ {printf "%.1f%%", \$3/\$2 * 100}')</code></p>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: $(free | awk '/^Mem:/ {printf "%.0f", \$3/\$2 * 100}')%">
                        $(free | awk '/^Mem:/ {printf "%.0f%%", \$3/\$2 * 100}')
                    </div>
                </div>
            </div>
            
            <div class="info-card resource-card">
                <h3>Total Swap</h3>
                <p><code>$(free -h | awk '/^Swap:/ {print \$2}')</code></p>
            </div>
            
            <div class="info-card resource-card">
                <h3>Used Swap</h3>
                <p><code>$(free -h | awk '/^Swap:/ {print \$3}')</code></p>
            </div>
            
            <div class="info-card resource-card">
                <h3>Free Swap</h3>
                <p><code>$(free -h | awk '/^Swap:/ {print \$4}')</code></p>
            </div>
            
            <div class="info-card resource-card">
                <h3>Swap Usage %</h3>
                <p><code>$(free | awk '/^Swap:/ {if (\$2 > 0) printf "%.1f%%", \$3/\$2 * 100; else print "0%"}')</code></p>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: $(free | awk '/^Swap:/ {if (\$2 > 0) printf "%.0f", \$3/\$2 * 100; else print "0"}')%">
                        $(free | awk '/^Swap:/ {if (\$2 > 0) printf "%.0f%%", \$3/\$2 * 100; else print "0%"}')
                    </div>
                </div>
            </div>
        </div>

        <h2>💿 Disk Information</h2>
        <div class="info-grid">
            <div class="info-card resource-card">
                <h3>Root Filesystem</h3>
                <p><code>$(df -h / | awk 'NR==2 {print \$1}')</code></p>
            </div>
            
            <div class="info-card resource-card">
                <h3>Total Disk Size</h3>
                <p><code>$(df -h / | awk 'NR==2 {print \$2}')</code></p>
            </div>
            
            <div class="info-card resource-card">
                <h3>Used Disk Space</h3>
                <p><code>$(df -h / | awk 'NR==2 {print \$3}')</code></p>
            </div>
            
            <div class="info-card resource-card">
                <h3>Available Disk Space</h3>
                <p><code>$(df -h / | awk 'NR==2 {print \$4}')</code></p>
            </div>
            
            <div class="info-card resource-card">
                <h3>Disk Usage %</h3>
                <p><code>$(df -h / | awk 'NR==2 {print \$5}')</code></p>
                <div class="progress-bar">
                    <div class="progress-fill $(df / | awk 'NR==2 {if (\$5+0 > 80) print "danger"; else if (\$5+0 > 60) print "warning"}')" style="width: $(df / | awk 'NR==2 {print \$5}')">
                        $(df / | awk 'NR==2 {print \$5}')
                    </div>
                </div>
            </div>
            
            <div class="info-card resource-card">
                <h3>Mount Point</h3>
                <p><code>$(df -h / | awk 'NR==2 {print \$6}')</code></p>
            </div>
            
            <div class="info-card resource-card">
                <h3>Filesystem Type</h3>
                <p><code>$(df -T / | awk 'NR==2 {print \$2}')</code></p>
            </div>
            
            <div class="info-card resource-card">
                <h3>Inodes Total</h3>
                <p><code>$(df -i / | awk 'NR==2 {print \$2}')</code></p>
#!/bin/bash

# Minimal EC2 User Data - Apache + Simple System Info Page

yum update -y
yum install -y httpd
systemctl enable --now httpd

# Basic metadata (IMDSv2)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
function meta() {
  curl -H "X-aws-ec2-metadata-token: $TOKEN" -s \
    "http://169.254.169.254/latest/meta-data/$1"
}

INST_ID=$(meta instance-id)
INST_TYPE=$(meta instance-type)
AZ=$(meta placement/availability-zone)
REGION=$(echo $AZ | sed 's/[a-z]$//')

AMI_ID=$(meta ami-id)
IP_PRIVATE=$(meta local-ipv4)
IP_PUBLIC=$(meta public-ipv4)

HOSTNAME=$(hostname)
UPTIME=$(uptime -p)
LOAD=$(uptime | awk -F'load average:' '{print $2}')
MEM=$(free -h | awk '/^Mem:/ {print $3 " / " $2}')
DISK=$(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}')

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
<title>EC2 Status</title>
<style>
body { font-family: sans-serif; margin: 40px; }
h1 { margin-bottom: 10px; }
pre { background: #f2f2f2; padding: 10px; border-radius: 6px; }
</style>
</head>
<body>
<h1>EC2 Instance Info</h1>
<pre>
Hostname:        $${HOSTNAME}
Instance ID:     $${INST_ID}
Instance Type:   $${INST_TYPE}
AMI ID:          $${AMI_ID}
AZ / Region:     $${AZ} / $${REGION}

Private IP:      $${IP_PRIVATE}
Public IP:       $${IP_PUBLIC}

Uptime:          $${UPTIME}
Load Average:    $${LOAD}
Memory:          $${MEM}
Disk (/):        $${DISK}

</pre>

</body>
</html>
EOF

echo "User data setup complete" >> /var/log/user-data.log

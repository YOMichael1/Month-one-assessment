#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
LOCAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head><title>TechCorp Web Server</title></head>
<body style="font-family:Arial; text-align:center; padding:50px;">
  <h1>TechCorp Web Application</h1>
  <p><strong>Instance ID:</strong> ${INSTANCE_ID}</p>
  <p><strong>Availability Zone:</strong> ${AVAILABILITY_ZONE}</p>
  <p><strong>Private IP:</strong> ${LOCAL_IP}</p>
</body>
</html>
EOF

useradd -m -s /bin/bash webadmin
echo "webadmin:TechCorp@2024!" | chpasswd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
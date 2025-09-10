#!/bin/bash
sudo -su ec2-user
sudo dnf install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx


#sudo -su ec2-user
#cd /home/ec2-user

#sudo aws s3 cp s3://bucket-for-code-jyde/application-code/web-tier web-tier --recursive
#cd web-tier
#sudo chown -R ec2-user:ec2-user /home/ec2-user/web-tier
#sudo chmod -R 755 /home/ec2-user
#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
#source ~/.bashrc
#nvm install 16
#nvm use 16
#cd /home/ec2-user/web-tier
#npm install
#npm audit fix

#cd /home/ec2-user/web-tier
#npm run build

#sudo yum install nginx -y	
#cd /etc/nginx
#sudo mv nginx.conf nginx-backup.conf

#sudo aws s3 cp s3://bucket-for-code-jyde/application-code/nginx.conf . 
#sudo chmod -R 755 /home/ec2-user
#sudo service nginx restart
#sudo chkconfig nginx on

#!/bin/bash
sudo -su ec2-user

cd /home/ec2-user
sudo aws s3 cp s3://bucket-for-code-jyde/application-code/app-tier app-tier --recursive

cd app-tier
sudo chown -R ec2-user:ec2-user /home/ec2-user/app-tier
sudo chmod -R 755 /home/ec2-user/app-tier

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install 16
nvm use 16
npm install -g pm2
npm install
npm audit fix

pm2 start index.js 	#(Start Application with PM2, PM2 is process manager for NodeJS)
pm2 logs            #(To see logs, run Ctrl+C to exit)
pm2 startup 			  #(Set PM2 to Start on Boot)
sudo env PATH=$PATH:/home/ec2-user/.nvm/versions/node/v16.20.2/bin /home/ec2-user/.nvm/versions/node/v16.20.2/lib/node_modules/pm2/bin/pm2 startup systemd -u ec2-user --hp /home/ec2-user
pm2 save			      #(Save the current configuration)
#curl http://localhost:4000/health #(To do the health check)
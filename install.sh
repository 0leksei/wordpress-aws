#! /bin/bash
chmod +x inventory/ec2.py
sudo rm -f private_key.pem

cd terraform
terraform init
terraform plan
terraform apply -auto-approve
export bastion_ip=$(terraform output bastion_ip)
export db_private_ip=$(terraform output db_private_ip)
export web_ip=$(terraform output web_ip)

cd ..
aws ssm get-parameters --names "/ssh_keys/aleksei-ec2-key" --with-decryption --query "Parameters[0].[Value]" --output text > private_key.pem
eval `ssh-agent -s`
chmod 400 private_key.pem
ssh-add private_key.pem

echo "Waiting to allow services on EC2 instances to start up"
sleep 40 

ssh-keyscan $bastion_ip >> $HOME/.ssh/known_hosts
ansible-playbook playbook.yml

echo -e "Open http://$web_ip in the browser to complete Wordpress setup"
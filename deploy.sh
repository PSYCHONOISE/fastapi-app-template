#!/bin/bash

set -e

# Prepare system
#
./deploy.pt1.sh

# Deploy application
#
cd ~ && git clone https://github.com/PSYCHONOISE/fastapi-nginx-gunicorn-application.git && cd fastapi-nginx-gunicorn-application
python3 -m venv env && . env/bin/activate
pip install -r requirements-dev.lock.txt
# uvicorn main:app --host 0.0.0.0 --port 8080 # Verify that everything went well by running the application, e.g. use `curl localhost:8080`
chmod u+x gunicorn_start

# Configuring Supervisor
#
sudo cp ./stencil/etc/supervisor/conf.d/fastapi-app.conf /etc/supervisor/conf.d/fastapi-app.conf # sudo ln -s supervisor-fastapi-app.conf /etc/supervisor/conf.d/ # don't work
sudo supervisorctl reread
sudo supervisorctl update
# sudo supervisorctl reload
#
# checking:
# sudo supervisorctl status fastapi-app
# or
# curl --unix-socket /home/fastapi-user/fastapi-nginx-gunicorn-application/run/gunicorn.sock localhost
# TechDebt: https://stackoverflow.com/questions/19737511/gunicorn-throws-oserror-errno-1-when-starting
#
# if you make changes to the code, you can restart the service to apply to changes by running this command:
# sudo supervisorctl restart fastapi-app

# Configuring Nginx
#
cp ./stencil/etc/nginx/sites-available/fastapi-app /etc/nginx/sites-available/fastapi-app
# nano fastapi-app # не забудте изменить значение server_name в файле
sudo ln -s /etc/nginx/sites-available/fastapi-app /etc/nginx/sites-enabled/fastapi-app
sudo nginx -t && sudo nginx -s reload && sudo systemctl status nginx

# Optionally, set up password authentication with Nginx
# sudo sh -c "echo -n 'grasper:' >> /etc/nginx/.htpasswd" #  Create a hidden file to store our username and password combinations.
# sudo sh -c "openssl passwd -apr1 >> /etc/nginx/.htpasswd" # Add an encrypted password entry for the username (by hands)
# cat /etc/nginx/.htpasswd # Optionally, you can see how the usernames and encrypted passwords are stored
# Also, you can create the password file using Apache Utilities: https://www.digitalocean.com/community/tutorials/how-to-set-up-password-authentication-with-nginx-on-ubuntu-14-04, https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/

# sudo apt install snapd
# sudo snap install core; sudo snap refresh core
# sudo snap install --classic certbot
# sudo ln -s /snap/bin/certbot /usr/bin/certbot

# https://app.zerossl.com/certificate/new
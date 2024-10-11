# FastAPI+Gunicorn+NGINX application template

If you make changes to the code, you can restart the service to apply to changes by running this command:
`sudo supervisorctl restart fastapi-app`

Test that the NGINX configuration file is OK: 
`sudo nginx -t`

Restart NGINX:
`sudo systemctl restart nginx`

Edit NGINX configuration:
`sudo nano /etc/nginx/sites-available/fastapi-app`
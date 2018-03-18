# deployment
This repository contains script for application deployment.

The configuration includes the config file for Apache, nginx, Gunicorn.
These are suitable for most common application deployment and targets mostly the WSGI like application deployment.



To Install gunicorn service:
## gunicorn service file
sudo nano /etc/systemd/system/gunicorn.service

sudo systemctl start gunicorn
sudo systemctl enable gunicorn
#!/usr/bin/env bash
#--------------------------------------------------
# Variables
#--------------------------------------------------

# SINCE EGMA SOURCE IS PRIVATE, AUTHORIZATION IS REQUIRED
GITHUB_USER=
GITHUB_PASS=

BASE_DIR=/vagrant
BACKEND_DIR=${BASE_DIR}/backend
FRONTEND_DIR=${BASE_DIR}/frontend


#--------------------------------------------------
# Update Server
#--------------------------------------------------
echo -e "\n---- Update Server ----"
sudo apt-get update
sudo apt-get upgrade -y


#--------------------------------------------------
# Install PostgreSQL
#--------------------------------------------------
sudo apt-get install -y locales
sudo locale-gen en_US.UTF-8
sudo /usr/sbin/update-locale LANG=en_US.UTF-8

sudo echo "LC_ALL=en_US.UTF-8" | sudo tee -a /etc/environment

sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | sudo tee -a /etc/apt/sources.list.d/pgdg.list
sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo apt-get update

sudo apt-get install -y postgresql-9.6
sudo -u postgres psql -c "CREATE DATABASE django;"
sudo -u postgres psql -c "CREATE USER django WITH PASSWORD 'django';"
sudo -u postgres psql -c "ALTER ROLE django SET client_encoding TO 'utf8';"
sudo -u postgres psql -c "ALTER ROLE django SET default_transaction_isolation TO 'read committed';"
sudo -u postgres psql -c "ALTER ROLE django SET timezone TO 'UTC';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE django TO django;"

sudo echo "host    all             all             0.0.0.0/0            md5" | sudo tee -a /etc/postgresql/9.6/main/pg_hba.conf
sudo -u postgres pg_ctlcluster 9.6 main reload

sudo echo "listen_addresses = '*'" | sudo tee -a /etc/postgresql/9.6/main/postgresql.conf
sudo echo "max_locks_per_transaction = 200" | sudo tee -a /etc/postgresql/9.6/main/postgresql.conf
sudo systemctl restart postgresql


#--------------------------------------------------
# Install System Dependencies
#--------------------------------------------------
echo -e "\n---- Install tool packages ----"
sudo apt-get install -y build-essential wget git python3-dev \
                        gettext zlib1g-dev libpq-dev libtiff5-dev \
                        libjpeg8-dev libfreetype6-dev liblcms2-dev \
                        libwebp-dev graphviz-dev

sudo curl https://bootstrap.pypa.io/get-pip.py | sudo python3


#--------------------------------------------------
# Clone EGMA Sources
#--------------------------------------------------
if [ -d "${BACKEND_DIR}" ]; then
    echo -e "\n---- Backend Source Exist ----"
    echo -e "\n---- Skipping ... ----"
    echo -e "\n---- Please consider pulling from source to update ----"
else
    echo -e "\n---- Clone Backend Source ----"
    sudo git clone https://${GITHUB_USER}:${GITHUB_PASS}@github.com/${GITHUB_USER}/egma_root.git ${BACKEND_DIR}
fi

if [ -d "${FRONTEND_DIR}" ]; then
    echo -e "\n---- Frontend Source Exist ----"
    echo -e "\n---- Skipping ... ----"
    echo -e "\n---- Please consider pulling from source to update ----"
else
    echo -e "\n---- Clone Frontend Source ----"
    sudo git clone https://${GITHUB_USER}:${GITHUB_PASS}@github.com/${GITHUB_USER}/egma_stream.git ${FRONTEND_DIR}
fi


#--------------------------------------------------
# Install Sources Dependencies
#--------------------------------------------------
echo -e "\n---- PIP Install Requirements Backend ----"
sudo -H pip3 install -r ${BACKEND_DIR}/requirements/local.txt

echo -e "\n---- NPM Install Requirements Frontend ----"
sudo apt-get install -y python-software-properties
sudo curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install -y nodejs
cd ${FRONTEND_DIR}
sudo npm install -g
sudo npm install -g @angular/cli


#--------------------------------------------------
# Install Mail Catcher
#--------------------------------------------------
echo -e "\n---- Install Mail Catcher ----"
sudo apt-get install -y libsqlite3-dev ruby ruby-dev
sudo gem install mailcatcher

sudo tee /lib/systemd/system/mailcatcher.service <<EOF
[Unit]
Description=MailCatcher Service
After=network.service vagrant.mount

[Service]
Type=simple
ExecStart=/usr/local/bin/mailcatcher --foreground --http-ip=0.0.0.0 --smtp-port=25
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo -e "\n---- Enable mailcatcher.service ----"
sudo systemctl daemon-reload
sudo chmod 755 /lib/systemd/system/mailcatcher.service
sudo chown root: /lib/systemd/system/mailcatcher.service
sudo systemctl enable mailcatcher.service

#--------------------------------------------------
# ENVIRONMENT VARIABLES
#--------------------------------------------------
echo -e "\n---- Enable mailcatcher.service ----"
sudo echo "DATABASE_URL=postgres://django:django@127.0.0.1:5432/django" | sudo tee -a ${HOME}/.bashrc

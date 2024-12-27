sudo apt update -y
sudo apt upgrade -y

# install nodejs+npm
sudo apt install nodejs -y
sudo apt install npm -y

# install git
sudo apt install git -y

# install pm2
sudo npm install pm2 -g

# install net-tools for routing (opsional)
sudo apt install net-tools -y

# install postgres
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update -y
sudo apt install postgresql-17 -y

psql --version
 
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo systemctl status postgresql
sudo systemctl restart postgresql

# Mengganti password user postgres
sudo -u postgres psql
ALTER USER postgres WITH PASSWORD 'fpkjkwebservice';
\q


# Test password postgres
psql -U postgres -h localhost -W

# Git clone repo web
git clone https://github.com/trdkhardani/kjk-example-webservice.git

# Create .env di dalam repo (local) web
cd kjk-example-webservice

echo "DATABASE_URL="postgresql://postgres:fpkjkwebservice@localhost:5432/fp_kjk?schema=public"
PORT=80
SENTRY_DSN="https://0dcefff844e1fdeff0a3e49d910089b4@o4508312339873792.ingest.us.sentry.io/4508312343674880"
EMAIL="tridiktya.dev@gmail.com"
APP_PASSWORD=ra ha si a
JWT_SECRET_KEY=c81e508ef5eeba8f9a37364008b9f273c31be75f904180ed22c8b4a0a1808607487c4726839e3198486ff681f727eba1" > ~/Desktop/kjk-example-webservice/.env

# Lanjutan
npm install

npx prisma migrate deploy

npx prisma generate

# Run Web
cd ~/Desktop/kjk-example-webservice/
sudo pm2 start app.js --update-env

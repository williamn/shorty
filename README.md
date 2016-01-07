# Shorty

A micro service to shorten urls, in the style that TinyURL and bit.ly made popular.

## Installation

Shorty is self contained using Docker but it possible to set it up from a fresh
Ubuntu Server 14.04

### Docker

1. Copy file .env.db.example to .env.db
1. Copy file .env.web.example to .env.web
1. Change the default environment variables in both .env files
1. Create and start containers: `docker-compose up`

### Ubuntu Server 14.04

#### Initial Setup

Create the user account

```
sudo adduser deploy
sudo adduser deploy sudo
```
For the rest of this tutorial, make sure you are logged in as the deploy user.

#### Installing Ruby

The first step is to install some dependencies.

```
sudo apt-get update
sudo apt-get install -y git libssl-dev libreadline-dev zlib1g-dev nodejs
```

We'll use rbenv to manage Ruby version for this application.

```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
```

Restart your shell so that PATH changes take effect.

Now check if rbenv was set up:

```
type rbenv
#=> "rbenv is a function"
```

Now install ruby-build, which provides the rbenv install command that simplifies
the process of installing new Ruby versions.

```
rbenv install 2.2.3
rbenv global 2.2.3
```

Now we tell Rubygems not to install the documentation for each package locally and then install Bundler

```
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install bundler
```

#### Installing Passenger + NGINX

These commands will install Passenger + Nginx through Phusion's APT repository

```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update
sudo apt-get install -y nginx-extras passenger
```

Edit /etc/nginx/nginx.conf and uncomment passenger_root and passenger_ruby

When you are finished with this step, restart Nginx:

```
sudo service nginx restart
```

After installation, please validate the install by running

`sudo passenger-config validate-install`

Finally, check whether Nginx has started the Passenger core processes.

Run `sudo passenger-memory-stats`

#### Installing MySQL

Install MySQL is to run the following command:

```
sudo apt-get install mysql-server mysql-client libmysqlclient-dev
```

Then secure your new MySQL installation by running `mysql_secure_installation`

#### Transferring the application code to the server

Pick a location in which to permanently store the application's code

```
cd /usr/share/nginx/html/
sudo mkdir shorty
sudo chown -R deploy shorty
```

Don't forget to add server public key to your GitHub account before cloning the code

```
cd shorty
git clone git@github.com:williamn/shorty.git .
```

#### Install application dependencies

Install dependencies only for production environment

```
bundle install --deployment --without development test
```

#### Configure database.yml and secrets.yml

Open the file config/database.yml and change the configuration for production environment

Generate a secret key. Run: `bundle exec rake secret`

Copy the output, insert it to file config/secrets.yml

#### Create and migrate the database

Create the database and migrate to latest schema by running

```
RAILS_ENV=production bundle exec rake db:create
RAILS_ENV=production bundle exec rake db:migrate
```

#### Edit NGINX configuration file

Change your `root` to

```
root /usr/share/nginx/html/shorty/public;
```

and turn on Passenger by adding this line

```
passenger_enabled on;
```

When you are done, restart Nginx:

```
sudo service nginx restart
```

## Usage

TODO: Write usage instructions

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History

TODO: Write history

## Credits

TODO: Write credits

## License

TODO: Write license
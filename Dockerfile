FROM ruby:2.3
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  nodejs
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install --jobs 20 --retry 5
ADD . /myapp

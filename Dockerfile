FROM ruby:2.6-rc

RUN apt-get update &&\
    # add support to unicode chars from keyboard: ç,ã,ô:
    apt-get install -y locales &&\
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && /usr/sbin/locale-gen &&\
    rm -rf /var/lib/apt/lists/*
ENV LANG en_US.UTF-8

# Fix Heroku sass bug
ENV BUNDLE_BUILD__SASSC=--disable-march-tune-native

RUN apt-get update -qq && apt-get install -y postgresql-client
# https://github.com/nodesource/distributions#installation-instructions
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y nodejs
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

RUN useradd -m myuser
USER myuser

# Start the main process.
CMD ["puma", "-C", "config/puma.rb"]

FROM ruby:2.6.5-alpine AS builder

# Install necessary dependencies
RUN apk add --update --no-cache \
        openssl \
        tar \
        build-base \
        tzdata \
        postgresql-dev \
        postgresql-client \
        nodejs \
    && wget https://yarnpkg.com/latest.tar.gz \
    && mkdir -p /opt/yarn \
    && tar -xf latest.tar.gz -C /opt/yarn --strip 1 \
    && mkdir -p /var/app

# Set env variables for building the stage
ENV PATH="$PATH:/opt/yarn/bin" BUNDLE_PATH="/gems" BUNDLE_JOBS=4

# Copy Gemfile to image
COPY Gemfile Gemfile.lock /var/app/
WORKDIR /var/app

# Install gems
RUN bundle install && rm -rf /gems/cache/*.gem \
    && find /gems/ -name "*.c" -delete \
    && find /gems/ -name "*.o" -delete

# Run yarn
RUN yarn install

# Copy files to image
COPY . /var/app

# Precompile assets
RUN bundle exec rails assets:precompile


# Final image
FROM ruby:2.6.5-alpine
LABEL maintainer="dlleal@uc.cl"

# Install necessary dependencies
RUN apk add --update --no-cache \
        openssl \
        tzdata \
        postgresql-dev \
        postgresql-client \
        nodejs
COPY --from=builder /gems/ /gems/
COPY --from=builder /var/app /var/app

# Set default environment
ENV RAILS_LOG_TO_STDOUT true
ENV PATH="$PATH:/gems/bin" BUNDLE_PATH="/gems" \
    GEM_PATH="/gems" GEM_HOME="/gems"

# Fix C.UTF-8 bugs
ENV LANG en_US.UTF-8

# Fix Heroku sass bug
ENV BUNDLE_BUILD__SASSC=--disable-march-tune-native

WORKDIR /var/app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["puma", "-C", "config/puma.rb"]

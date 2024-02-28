FROM ruby:3.2.3-alpine3.19

ENV PATH="/usr/local/bundle/bin:${PATH}"
ENV RUBY_YJIT_ENABLE=1

COPY . /app

WORKDIR /app

RUN apk update && apk upgrade --no-cache \
  && apk add --no-cache libpq-dev build-base git bash tzdata gcompat postgresql \
  && gem install rails railties bundler \
  && bundle install --jobs 4 --no-cache \
  && bundle exec bootsnap precompile

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rails s -b 0.0.0.0 -p 3000"]

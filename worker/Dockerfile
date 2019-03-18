FROM ruby:2.6.0

ENV RAILS_ROOT /src
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

ARG BUNDLE_WITHOUT=development:test
ENV BUNDLE_WITHOUT ${BUNDLE_WITHOUT}
COPY Gemfile Gemfile.lock ./

EXPOSE 3000
ARG RAILS_ENV=production
ENV RAILS_ENV ${RAILS_ENV}

RUN bundle install

COPY . ./

CMD bundle exec puma -C config/puma.rb

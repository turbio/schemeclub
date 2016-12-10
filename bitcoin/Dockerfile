FROM ruby
RUN mkdir /bitcoin
WORKDIR /bitcoin
ADD Gemfile /bitcoin/Gemfile
ADD Gemfile.lock /bitcoin/Gemfile.lock
RUN bundle install
ADD . /bitcoin

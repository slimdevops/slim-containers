FROM ruby:latest

# Set a variable for the install location.
ARG RAILS_ROOT=/usr/src/app
RUN mkdir -p $RAILS_ROOT
ENV RAILS_ENV development
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"
WORKDIR $RAILS_ROOT
#Copy Source Files
COPY . .
#Remove the lock file and fetch all gems again
RUN rm -f Gemfile.lock
RUN bundle install

RUN chmod +x bin/start
EXPOSE 3000
CMD ["bin/start"]
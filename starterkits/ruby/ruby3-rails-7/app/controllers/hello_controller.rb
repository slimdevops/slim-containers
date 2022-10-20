class HelloController < ApplicationController
    def index
        yourip = request.remote_ip
        ruby_version = RUBY_VERSION
        rails_version = Rails::VERSION::STRING
        render json: { hello:"world", yourip:yourip,ruby_version:ruby_version,rails_version:rails_version }
      end
end

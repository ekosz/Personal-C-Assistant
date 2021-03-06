# Third-Party
require 'rubygems'
require 'bundler'
Bundler.setup

# Sinatra
require 'sinatra'
require 'haml'
require 'redis'
require 'ohm'
require 'shield'

# Helpers
require_relative 'app/helpers/init'

class Main < Sinatra::Base

  helpers Sinatra::Partials, Sinatra::RedirectWithObjects, Sinatra::TwilioHelpers
  helpers Shield::Helpers

  configure :development, :test do
    REDIS = Redis.new
  end

  configure :production do
    # This needs to be changed if not using heroku
    uri = URI.parse(ENV["REDISTOGO_URL"])
    REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    set :sass, { :style => :compressed }
  end

  configure do
    # Configure public directory
    set :public, File.join(File.dirname(__FILE__), 'public')

    set :views, File.dirname(__FILE__)+'/app/views'

    # Configure HAML and SASS
    set :haml, { :format => :html5 }

    enable :sessions

    REDIS.set("extention:key", 100) if REDIS.get("extention:key").nil?
    Ohm.redis = Main::REDIS
  end
end

# Models
require_relative 'app/models/init'
# Routes
require_relative 'app/routes/init'

if User.find(:username=>'admin').size == 0
  User.create(:username=>'admin', :password=>'admin')
end

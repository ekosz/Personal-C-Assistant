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
require_relative 'lib/helpers/init'

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

    set :views, File.dirname(__FILE__)+'/lib/views'

    # Configure HAML and SASS
    set :haml, { :format => :html5 }

    enable :sessions

    REDIS.set("extention:key", 100) if REDIS.get("extention:key").nil?
  end
end

# Models
require_relative 'lib/models/init'
# Routes
require_relative 'lib/routes/init'

if User.find(:username=>'admin').size == 0
  User.create(:username=>'admin', :password=>'admin')
end

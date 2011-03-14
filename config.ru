#require 'rubygems'
#require 'bundler'
#require 'redis'
#require 'json'
#require 'net/http'
#require 'time'
#require 'builder'
#Bundler.setup
#
#require 'sinatra'
#require './lib/partials'
#require './lib/redirect_with_objects'
#require './lib/twilio_helpers'
#require './lib/pca_base'
#require './lib/number'
#require './lib/group'
#require './lib/user'
#require './main'
#run Main

$: << "lib"

require 'main'
run Main


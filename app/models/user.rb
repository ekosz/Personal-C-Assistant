# user.rb
# Author: Eric Koslow
require 'net/http'
require 'time'

class User < PCABase
  extend Shield::Model

  attribute :name
  attribute :username
  index :username
  attribute :crypted_password
  attribute :number
  attribute :extention
  attribute :gcal_url

  def inilize(arg={}) 
    if arg.is_a? Hash
      arg['extention'] ||= generate_extention
      super(arg)
    else
      super(arg)
    end
  end

  def self.lookup_from_extention(ex)
    User.find(:extention=>ex).first
  end

  def self.fetch(username)
    find(:username=>username).first
  end

  def available?
    if @gcal_url
      now = Time.now.utc.xmlschema
      url = @gcal_url+"/free-busy?alt=json&start-min=#{now}&start-max=#{now}"
      res = JSON.parse(Net::HTTP.get URI.parse url)['feed']['entry']
      return true if res.nil? || res[0]['title']['$t'] != "busy"
      #TODO: Set @custom_message if there is one
      false
    else
      return true
    end
  end

  def password=(password)
    write_local(:crypted_password, Shield::Password.encrypt(password))
    @password = password
  end
  
  private
  
  def generate_extention
    Main::REDIS.incr "extention:key"
  end


end

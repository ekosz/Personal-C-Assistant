# user.rb
# Author: Eric Koslow

class User < PCABase
  attr_accessor :name, :number, :extention, :gcal_url

  def inilize(arg) 
    if arg.is_a? Fixnum
      lookup_from_extention(arg)
    elsif arg.is_a? Hash
      arg['extention'] ||= generate_extention
      super(arg)
    else
      super(arg)
    end
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
  
  private
  
  def generate_extention
    Main::REDIS.incr "extention:key"
  end

  def lookup_from_extention(ex)
    data = Main::REDIS.get(Main::REDIS.get('extention:'+ex.to_s))
    create_from_hash JSON.parse(data)
  end

end

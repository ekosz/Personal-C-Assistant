module Sinatra::TwilioHelpers
  def get_name(number)
    Main::REDIS.keys.select {|s| s=~ /number/}.each do |key|
      num = JSON.parse(Main::REDIS.get(key))
      if num['number'] == number
        return num['name']
      end
    end
    nil
  end
        
end


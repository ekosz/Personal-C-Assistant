module Sinatra::TwilioHelpers
  def get_name(number)
    data = JSON.parse(Main::REDIS.get("number:#{number[2..-1]}"))
    if data
      data['name']
    else
      nil
    end
  end
end


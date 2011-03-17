require 'builder'

class Main < Sinatra::Base
  # TWILIO #
  ##########

  post '/twilio' do
    puts request.POST
    builder do |xml|
      xml.instruct!
      xml.Response do
        to_say = "Hello #{get_name(params[:From][2..-1]) || ''}."
        if ENV['multi_user'] == true
          to_say += "Please enter the 3 diget extention now."
          xml.Gather(:numDigits=>"3",:action=>"/twilio/check_avalible") do
            xml.Say to_say
          end
          xml.Say "Sorry no input"
        else
          xml.Say to_say
          xml.Redirect('twilio/check_avalible') 
        end
      end
    end
  end

  post '/twilio/check_avalible' do
    if params[:Digits]
      @user = User.new(params[:Digits])
    else
      @user = User.all[0]
    end
    if @user.available?
      builder do |xml|
        xml.instruct!
        xml.Response do
          xml.Say "Connecting"
          xml.Dial @user.number
        end
      end
    else
      builder do |xml|
        xml.instruct!
        xml.Response do
          xml.Gather(:action=>'/twilio/call/'+@user.number,:numDigits=>"1") do
            # TODO: Use @user.message when it is implemented
            xml.Say "Sorry #{@user.name} is #{'not avalible'}.
                     If this is an emergancy, press any key to connect"
          end
        end
      end
    end
  end

  post '/twilio/call/:number' do
    builder do |xml|
      xml.instruct!
      xml.Response do
        xml.Say "Connecting"
        xml.Dial params[:number].to_i
      end
    end
  end
end

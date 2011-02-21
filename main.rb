class Main < Sinatra::Base

  helpers Sinatra::Partials, Sinatra::RedirectWithObjects, Sinatra::TwilioHelpers

  configure :development do
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

    # Configure HAML and SASS
    set :haml, { :format => :html5 }

    enable :sessions

    REDIS.set("extention:key", 100) if REDIS.get("extention:key").nil?
  end

  get "/css/style.css" do
    content_type 'text/css'
    sass :"css/style"
  end

  get '/' do
    haml :index
  end

  # All of an object
  # i.e. /numbers, /users, /groups
  get %r{^\/([^\/]+)s$} do |obj|
    instance_variable_set('@gens', Kernel.const_get(obj.capitalize).all)
    @new_path = request.path_info+'/new'
    haml :generals
  end

  # Create a new object
  # i.e. /numbers/new, /users/new, /groups/new
  get %r{^\/([^\/]+)s\/new$} do |obj|
    @class = Kernel.const_get(obj.capitalize)
    haml :general_new
  end

  # An individual Object
  # i.e. /number/5, /user/ekosz, /group/CSH
  get %r{^\/([^\/]+[^s])\/([^\/.]+)$} do |obj, id|
    self.instance_variable_set('@gen', 
                               Kernel.const_get(obj.capitalize).new(id))

    haml :general
  end

  # Edit an exsiting object
  # i.e. /number/5/edit, /user/ekosz/edit, /group/CSH/edit
  get %r{^\/([^\/]+[^s])\/([^\/]+)\/edit$} do |obj, id|
    self.instance_variable_set('@gen', 
                               Kernel.const_get(obj.capitalize).new(id))
    haml :general_edit
  end

  # Create a new obect
  # i.e. /numbers/new, /users/new, /groups/new
  post %r{^\/([^\/]+)s\/new$} do |obj|
    request.body.rewind  # in case someone already read it
    self.instance_variable_set('@'+obj, 
                               Kernel.const_get(obj.capitalize).new(request.POST))
    self.instance_variable_get('@'+obj).save

    redirect self.instance_variable_get('@'+obj)
  end

  # Edit an exsisting object
  # i.e. /number/5/edit, /user/ekosz/edit, /group/CSH/edit
  put %r{^\/([^\/]+[^s])\/([^\/]+)\/edit$} do |obj, id|
    #TODO: Fill in
  end

  # TWILIO #
  ##########

  post '/twilio' do
    builder do |xml|
      xml.instruct!
      xml.Responce do
        if ENV['multi_user'] == true
          to_say = "Hello #{get_name(params[:From][2..-1]) || ''}, 
                    please enter the 3 diget extention now."
          xml.Gather(:numDigits=>"3",:action=>"/twilio/check_avalible") do
            xml.Say to_say
          end
          xml.Say "Sorry no input"
        else
          xml.Redirect(:user_id => User.all[0].id)
        end
      end
    end
  end

  post '/twilio/check_avalible' do
    @user = User.new(params[:user_id] || params[:Digits])
    if @user.availble?
      builder do |xml|
        xml.instruct!
        xml.Responce do
          xml.Say "Connecting"
          xml.Dial @user.number
        end
      end
    else
      builder do |xml|
        xml.instruct!
        xml.Responce do
          xml.Gather(:action=>'/twilio/call/'+@user.number,:numDigits=>"1") do
            xml.Say "Sorry #{@user.name} is #{@user.message || 'not avalible'}.
                     If this is an emergancy, press any key to connect"
          end
        end
      end
    end
  end

  post '/twilio/call/:number' do
    builder do |xml|
      xml.instruct!
      xml.Responce do
        xml.Say "Connecting"
        xml.Dial params[:number].to_i
      end
    end
  end


end
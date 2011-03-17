class Main < Sinatra::Base
  get '/login' do
    haml :login
  end

  post '/login' do
    if login(User, params[:username], params[:password])
      redirect '/numbers'
    else
      @error = "Wrong username / password combo"
      haml :login
    end
  end

  get '/logout' do
    logout(User)
    redirect '/'
  end
end

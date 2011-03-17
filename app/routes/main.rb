class Main < Sinatra::Base

  get "/css/style.css" do
    content_type 'text/css'
    sass :"css/style"
  end

  get '/' do
    haml :index
  end

end

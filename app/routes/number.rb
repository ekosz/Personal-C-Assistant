class Main < Sinatra::Base
  get '/numbers' do
    ensure_authenticated(User)
    @numbers = Number.all
    haml :"numbers/index"
  end

  get '/numbers/new' do
    ensure_authenticated(User)
    @number = Number.new
    haml :"numbers/new"
  end

  get '/numbers/:id' do
    ensure_authenticated(User)
    @number = Number[params[:id]]
    haml :"numbers/show"
  end

  get '/numbers/:id/edit' do
    ensure_authenticated(User)
    @number = Number[params[:id]]
    haml :"numbers/edit"
  end

end

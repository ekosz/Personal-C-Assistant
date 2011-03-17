class Main < Sinatra::Base
  get '/numbers' do
    @numbers = Number.all
    haml :"numbers/index"
  end

  get '/numbers/new' do
    @number = Number.new
    haml :"numbers/new"
  end

  get '/numbers/:id' do
    @number = Number[params[:id]]
    haml :"numbers/show"
  end

  get '/numbers/:id/edit' do
    @number = Number[params[:id]]
    haml :"numbers/edit"
  end

end

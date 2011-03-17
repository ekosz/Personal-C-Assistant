module Sinatra::RedirectWithObjects
  
  def redirect(uri, *args)
    if uri.is_a? String
      super(uri, *args)
    else
      super("/#{uri.class.to_s.downcase}s/#{uri.id}", *args)
    end
  end

end

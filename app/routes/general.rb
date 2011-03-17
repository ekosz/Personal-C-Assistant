class Main < Sinatra::Base
  # All of an object
  # i.e. /numbers, /users, /groups
  get %r{^\/([^\/]+)s$} do |obj|
    ensure_authenticated(User)
    instance_variable_set('@gens', Kernel.const_get(obj.capitalize).all)
    @new_path = request.path_info+'/new'
    haml :generals
  end

  # Create a new object
  # i.e. /numbers/new, /users/new, /groups/new
  get %r{^\/([^\/]+)s\/new$} do |obj|
    ensure_authenticated(User)
    @class = Kernel.const_get(obj.capitalize)
    haml :general_new
  end

  # An individual Object
  # i.e. /number/5, /user/ekosz, /group/CSH
  get %r{^\/([^\/]+[^s])\/([^\/.]+)$} do |obj, id|
    ensure_authenticated(User)
    self.instance_variable_set('@gen', 
                               Kernel.const_get(obj.capitalize).lookup_from_id(id))

    haml :general
  end

  # Edit an exsiting object
  # i.e. /number/5/edit, /user/ekosz/edit, /group/CSH/edit
  get %r{^\/([^\/]+[^s])\/([^\/]+)\/edit$} do |obj, id|
    ensure_authenticated(User)
    self.instance_variable_set('@gen', 
                               Kernel.const_get(obj.capitalize).lookup_from_id(id))
    haml :general_edit
  end

  # Create a new obect
  # i.e. /numbers/new, /users/new, /groups/new
  post %r{^\/([^\/]+)s\/new$} do |obj|
    ensure_authenticated(User)
    request.body.rewind  # in case someone already read it
    self.instance_variable_set('@'+obj, 
                               Kernel.const_get(obj.capitalize).new(request.POST))
    self.instance_variable_get('@'+obj).save

    redirect self.instance_variable_get('@'+obj)
  end

  # Edit an exsisting object
  # i.e. /number/5/edit, /user/ekosz/edit, /group/CSH/edit
  put %r{^\/([^\/]+[^s])\/([^\/]+)\/edit$} do |obj, id|
    #ensure_authenticated(User)
    #TODO: Fill in
  end
end

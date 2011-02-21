#pca_base.rb
#Author: Eric Koslow

class PCABase

  attr_accessor :id

  def initialize(arg)
    if arg.is_a? Hash
      create_from_hash(arg)
    elsif arg.is_a? String
      lookup_from_id(arg)
    else
      raise InvalidArgument, arg
    end
  end
  
  def self.all
    array = Array.new
    Main::REDIS.keys(self.to_s.downcase+':*').each do |key| 
      array << self.new(key.split(':')[1])
    end
    return array
  end

  def self.accessors
    instance_methods(false).keep_if {|v| v=~/\w+=/}.map {|m| '@'+m.to_s[0..-2]}
  end

  def save
    Main::REDIS.set self.class.to_s.downcase+':'+@id, self.to_json
  end

  def delete
    Main::REDIS.del self.class.to_s.downcase+':'+@id
  end

  def to_json(*opt)
    hash = Hash.new
    vars = self.instance_variables
    vars.each {|var| hash[var.to_s[1..-1]] = instance_variable_get(var)}
    hash.to_json(*opt)
  end

  def try?(sym, *args)
    if self.respond_to? sym
      self.send(sym, *args)
    else
      false
    end
  end

  private

  def create_from_hash(arg)
    puts "I am assigning by a hash: "+arg.inspect
    arg.each_pair {|key, val| self.instance_variable_set('@'+key,val)}
    if @id.nil?
      @id = generate_id
    end
  end

  def lookup_from_id(id)
    id = self.class.to_s.downcase+':'+id
    puts "I am looking up an ID: "+id
    data = Main::REDIS.get id
    if data.nil?
      raise IdNotFound, id
    end
    data = JSON.parse data
    create_from_hash(data)
  end

  def generate_id
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    size = 7
    Array.new(size){||chars[rand(chars.size)]}.join
  end

end
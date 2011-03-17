#pca_base.rb
#Author: Eric Koslow

require 'json'
require 'ohm'

class PCABase < Ohm::Model

  def self.accessors
    instance_methods(false).keep_if {|v| v=~/\w+=/}.map {|m| '@'+m.to_s[0..-2]}
  end

  def self.lookup_from_id(id)
    self[id]
  end

  def try?(sym, *args)
    if self.respond_to? sym
      self.send(sym, *args)
    else
      false
    end
  end
end

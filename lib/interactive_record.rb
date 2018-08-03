require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

  def initialize(options = {})
    options.each { |property, value| self.send("#{property}=", value)}
  end 
end
require 'compaa/null_object'

module Watir
  class Browser
    def self.new
      Compaa::NullObject.new
    end
  end
end

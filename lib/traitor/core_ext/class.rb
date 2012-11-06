module Traitor
  module Class
    def traits
      @traits ||= []
    end

    def uses(trait)
      traits << trait
    end
  end
end

Class.send :include, Traitor::Class

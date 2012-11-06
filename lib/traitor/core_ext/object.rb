module Traitor
  module Object
    def method_missing(m, *args, &block)
      Trait.check_conflict(self.class)
      super unless trait = self.class.traits.detect { |t| t.implements?(m) }
      trait.call(self, m, *args, &block)
    end

    def trait_send(trait, m, *args, &block)
      trait.call(self, m, *args, &block)
    end
  end
end

Object.send :include, Traitor::Object

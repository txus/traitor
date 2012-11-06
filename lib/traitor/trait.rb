require 'traitor/conflict_check'

module Traitor
  class Trait
    def initialize(&block)
      @module_block = block
      @container = Module.new(&block)
    end

    def trait_methods
      @container.instance_methods(false)
    end

    def implements?(m)
      trait_methods.include?(m)
    end

    def call(host, m, *args, &block)
      metaclass = class << host; self; end
      blk = @module_block

      refinement = Module.new do
        refine metaclass, &blk
      end

      host.send :using, refinement
      host.send m, *args, &block
    end

    def self.check_conflict(host_class)
      ConflictCheck.check(host_class)
    end
  end
end

Trait = Traitor::Trait

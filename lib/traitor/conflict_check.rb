module Traitor
  module ConflictCheck
    class TraitConflict < StandardError
    end

    def check(host_class)
      conflicts = []
      traits = host_class.traits
      traits.each do |t|
        traits.reject { |other| other == t }.each do |other|
          t.trait_methods.each do |m|
            conflicts << m if other.implements?(m)
          end
        end
      end
      conflicts.delete_if do |c|
        host_class.instance_methods(false).include?(c)
      end
      return false if conflicts.empty?

      output = "Conflicting methods: #{conflicts.uniq.map {|c| "##{c}"}.join(', ')}"
      raise TraitConflict, output
    end
    module_function :check
  end
end

TraitConflict = Traitor::ConflictCheck::TraitConflict

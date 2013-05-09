require 'set'
require 'json'

module PGM
  class Factor

    attr_reader :vars

    def self.joint_distribution(*factors)
      factors.reduce(&:*)
    end

    def cardinality
      Hash[vars.keys.map(&:to_a).flatten.uniq.group_by(&:keys).
        map{|k,v| [k.first, v.length]}]
    end

    def variables
      vars.keys.map(&:to_a).flatten.map(&:keys).flatten.uniq.sort
    end

    def to_s
      vars.map{|s,v| [s.to_a.map(&:to_a).map(&:first).
        map{|k,v| "#{k}#{"[#{v}]" if v}"}.join(" | "), v].join(" | ")}.
        sort.join("\n")
    end

    def initialize(*vars, &blk)
      @vars = {}

      unless vars.empty?
        @vars = vars.first
      end

      if block_given?
        metaclass = class << self; self; end
        metaclass.send(:define_method, :method_missing) do |method, *args, &block|
          FactorRelationship.new(method) do |var|
            @vars.merge!(var)
          end
        end

        begin
          instance_eval &blk
        ensure
          metaclass.send(:remove_method, :method_missing)
        end
      end
    end

    def marginalize(factor)
      new_vars = Hash[vars.map{|k,v| [k.clone, v]}.map{|k,v|
        [k.reject{|x| x.keys.include?(factor)}, v]}.group_by(&:first).map{|k,v|
          [Set.new(k), v.map(&:last).reduce(&:+)]}]

      Factor.new(new_vars)
    end

    def *(factor)
      variables_set = [self,factor].map(&:variables).flatten.uniq.sort

      new_vars = Hash[vars.to_a.product(factor.vars.to_a).select{|x|
        x.map(&:first).reduce(&:+).map(&:keys).flatten.sort == variables_set}.
          map{|x| x.transpose.instance_eval{|x| [x[0].map(&:clone).
          reduce(&:merge), x[1].reduce(&:*)]}}]

      Factor.new(new_vars)
    end
  end

  class FactorRelationship
    attr_reader :level

    def initialize(level, &blk)
      @level = {level => nil}
      @args = ::Set.new([@level])
      @blk = blk
    end

    def method_missing(method, *args, &block)
      method
    end

    def [](arg)
      if arg.class == FactorRelationship
        @level[@level.keys.first] = arg.level.keys.first
      else
        @level[@level.keys.first] = arg
      end
      self
    end

    def |(arg)
      if arg.class == FactorRelationship
        @args << arg.level
        self
      else
        @blk.call({@args => arg})
      end  
    end
  end
end

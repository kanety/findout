module Findout
  class Chainer
    attr_reader :relation 

    def initialize(base)
      @base = base
      @relation = base.relation
    end

    def run(query)
      chain!(query)
      @relation
    end

    private

    def chain!(query)
      if query.is_a?(Array)
        query.each { |q| chain!(q) }
      elsif query.is_a?(Hash)
        query.keys.each do |key|
          if chain = @base.class.chains[key.to_sym]
            eval_chain(chain, query[key])
          end
        end
      end
    end

    def eval_chain(chain, val)
      result = @base.instance_exec(val, &to_proc(chain))
      @relation.merge!(result) if result
    end

    def to_proc(chain)
      if chain.is_a?(Proc)
        chain
      else
        @base.method(chain).to_proc
      end
    end
  end
end

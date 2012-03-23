class YamldiffError
  attr_reader :key, :context
  def initialize(key, context)
    @key = key
    @context = context
  end
end

class YamldiffKeyError < YamldiffError; end
class YamldiffKeyValueTypeError < YamldiffError; end
class YamldiffKeyValueError < YamldiffError; end

class YamldiffError
  attr_reader :key, :context
  def initialize(key, context)
    @key = key
    @context = context
  end
end

class YamldiffKeyError < YamldiffError
  def to_s
    "Missing key: #{@key} in path #{@context.join(".")}"
  end
end

class YamldiffKeyValueTypeError < YamldiffError
  def to_s
    "Key value type mismatch: #{@key} in path #{@context.join(".")}"
  end
end

class YamldiffKeyValueError < YamldiffError
  def initialize(key, context, diff = nil)
    super key, context
    @diff = diff
  end

  def to_s
    output = []
    output << "Key value mismatch: #{@key} in path #{@context.join(".")}"
    if @diff
      output << "Diff:"
      output << @diff
    end
    output.join("\n")
  end
end

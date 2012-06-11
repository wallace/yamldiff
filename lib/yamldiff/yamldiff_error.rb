class YamldiffError
  attr_reader :key, :context
  def initialize(key, context)
    @key = key
    @context = context
  end
end

class YamldiffKeyError < YamldiffError
  def to_s
    "Missing key: #{@context.join(".")}.#{@key}"
  end
end

class YamldiffKeyValueTypeError < YamldiffError
  def to_s
    "Key value type mismatch: #{@context.join(".")}.#{@key}"
  end
end

class YamldiffKeyValueError < YamldiffError
  def initialize(key, context, diff = nil)
    super key, context
    @diff = diff
  end

  def to_s
    output = []
    output << "Key content differs: #{@context.join(".")}.#{@key}"
    if @diff
      output << "Diff:"
      output << @diff
    end
    output.join("\n")
  end
end

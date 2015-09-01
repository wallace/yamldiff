class YamldiffError
  attr_reader :key, :context

  def initialize(key, context)
    @key = key
    @context = context
  end

  def path
    (@context + [@key]).join('.')
  end
end

class YamldiffKeyError < YamldiffError
  def to_s
    "Missing key: #{path}"
  end
end

class YamldiffKeyValueError < YamldiffError
  attr_reader :diff

  def initialize(key, context, diff = nil)
    super key, context
    @diff = diff
  end

  def to_s
    output = ["Key content differs: #{path}"]
    if @diff
      output << "Diff:" << @diff
    end
    output.join("\n")
  end
end

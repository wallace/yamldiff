require "yamldiff/version"

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

class Yamldiff
  class << self
    # Compare the two yaml files
    def diff_yaml(first, second, errors_for = {})
      primary               = YAML.load(File.open(first))
      secondary             = YAML.load(File.open(second))
      errors_for[secondary] = compare_hashes(first, second)
    end

    # Iterate through all keys in the first hash, checking each key for
    #   1. existence
    #   2. value class equivalence
    #   3. value type equivalence
    # in the second hash.
    #
    # Adapted from http://stackoverflow.com/a/6274367/91029
    def compare_hashes(first, second, context = [])
      errors = []

      first.each do |key, value|
        unless second.key?(key)
          errors << YamldiffKeyError.new(key, context) # "Missing key : #{key} in path #{context.join(".")}"
          next
        end

        value2 = second[key]
        if (value.class != value2.class)
          errors << YamldiffKeyValueTypeError.new(key, context) # "Key value type mismatch : #{key} in path #{context.join(".")}"
          next
        end

        if value.is_a?(Hash)
          errors << compare_hashes(value, second[key], (context << key))
          next
        end

        if (value != value2)
          errors << YamldiffKeyValueError.new(key, context) # "Key value mismatch : #{key} in path #{context.join(".")}"
        end
      end

      errors.flatten
    end
  end
end

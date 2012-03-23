class Yamldiff
  class << self
    # Compare the two yaml files
    def diff_yaml(first, second, errors_for = {})
      primary            = YAML.load(File.open(first))
      secondary          = YAML.load(File.open(second))
      errors_for[second] = compare_hashes(primary, secondary)
      errors_for
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

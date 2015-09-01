class Yamldiff
  class << self
    # Compare the two yaml files
    def diff_yaml(first, second, errors_for = {})
      primary            = YAML.load(ERB.new(File.read(first)).result)
      secondary          = YAML.load(ERB.new(File.read(second)).result)
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
      first.each_with_object([]) do |(key, value), errors|
        unless second.key?(key)
          errors << YamldiffKeyError.new(key, context)
          next
        end

        value2 = second[key]
        if (value.class != value2.class)
          errors << YamldiffKeyValueError.new(key, context, Diffy::Diff.new(value.to_s + "\n", value2.to_s + "\n"))
          next
        end

        if value.is_a?(Hash)
          errors << compare_hashes(value, second[key], context + [key])
          next
        end

        if (value != value2)
          errors << YamldiffKeyValueError.new(key, context, Diffy::Diff.new(value.to_s + "\n", value2.to_s + "\n"))
        end
      end.flatten
    end
  end
end

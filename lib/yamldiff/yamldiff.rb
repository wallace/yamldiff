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
          errors << YamldiffKeyValueTypeError.new(key, context)
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

class Yamlcomm
  class << self
    # Compare the two yaml files
    def comm_yaml(first, second, common = [])
      primary            = YAML.load(ERB.new(File.read(first)).result)
      secondary          = YAML.load(ERB.new(File.read(second)).result)
      common = compare_hashes(primary, secondary)
      common
    end

    # Adapted from yamldiff.rb
    def compare_hashes(first, second, context = [])
      common = []

      first.each do |key, value|

        unless second
          next
        end

        if value.is_a?(Hash)
          common << compare_hashes(value, second[key], context + [key])
          next
        end

        if second.key?(key)
          value2 = second[key]
          if value.class == value2.class
            if value == value2
              s = ""
              context.each { |p| s += p + "." }
              common << s + key
            end
          end
        end

      end

      common.flatten
    end
  end
end

require "spec_helper"

describe Yamldiff do
  subject { Yamldiff }

  describe ".compare_hashes" do
    it "should be empty for equal hashes" do
      expect(subject.compare_hashes({ a: 1 }, { a: 1 })).to be_empty
    end

    it "should be empty for nested hashes" do
      first  = { a: { b: 2 } }
      second = { a: { b: 2 } }
      expect(subject.compare_hashes(first, second)).to be_empty
    end

    it "should recognize when a key is missing" do
      first  = { a: 1, b: 2 }
      second = { a: 1 }
      result = subject.compare_hashes(first, second).first

      expect(result).to be_an_instance_of(YamldiffKeyError)
      expect(result.key).to eql :b
      expect(result.context).to be_empty
    end

    it "should recognize when two keys' values are of a different type" do
      first  = { a:  1  }
      second = { a: "1" }
      result = subject.compare_hashes(first, second).first

      expect(result).to be_an_instance_of(YamldiffKeyValueError)
      expect(result.key).to eql :a
      expect(result.context).to be_empty
    end

    it "should recognize when two keys' values are not equal" do
      first  = { a: { b: 2 } }
      second = { a: { b: 1 } }
      result = subject.compare_hashes(first, second).first

      expect(result).to be_an_instance_of(YamldiffKeyValueError)
      expect(result.key).to eql :b
      expect(result.context).to eql [:a]
    end
  end

  describe ".diff_yaml" do
    it "returns no errors when the files have the same YAML structure", fakefs: true do
      File.open("./en.yml", "w") do |f|
        f.puts("en: ")
        f.puts("  app_name: 'Verbosefish'")
        f.puts("blah: 'Hello'")
      end
      File.open("./es.yml", "w") do |f|
        f.puts("blah: 'Hello'")
        f.puts("en: ")
        f.puts("  app_name: 'Verbosefish'")
      end

      expect(subject.diff_yaml("./en.yml", "./es.yml").values).to all(eql([]))
    end

    it "returns one top level error", fakefs: true do
      first  = "./en.yml"
      second = "./es.yml"
      File.open(first, "w") do |f|
        f.puts("en: ")
        f.puts("  app_name: 'Verbosefish'")
      end
      File.open(second, "w") do |f|
        f.puts("es: ")
        f.puts("  app_name: 'Verboszefish'")
      end

      result = subject.diff_yaml(first, second)
      expect(result[second].first.key).to eql("en")
    end

    it "returns second level error", fakefs: true do
      first  = "./en.yml"
      second = "./es.yml"
      File.open(first, "w") do |f|
        f.puts("en: ")
        f.puts("  app_name: 'Verbosefish'")
      end
      File.open(second, "w") do |f|
        f.puts("en: ")
        f.puts("  app_name: 'Verboszefish'")
      end

      result = subject.diff_yaml(first, second)
      expect(result[second].first.key).to eql("app_name")
      expect(result[second].first.context).to eql(["en"])
    end

    it "returns third level error", fakefs: true do
      first  = "./en.yml"
      second = "./es.yml"

      File.open(first, "w") do |f|
        f.puts("en:")
        f.puts("  app_name:")
        f.puts("    foo: 'Verbosefish'")
        f.puts("  baz:")
        f.puts("    bar: 'Verbosefish'")
      end
      File.open(second, "w") do |f|
        f.puts("en:")
        f.puts("  app_name:")
        f.puts("    foo: 'Verbosefish'")
        f.puts("  baz:")
        f.puts("    bar: 'Something completely different'")
      end

      result = subject.diff_yaml(first, second)
      expect(result[second].first.key).to eql("bar")
      expect(result[second].first.context).to eql(["en", "baz"])
    end

    it "diffs the output when the values are different and passes diff to error" do
      first  = "./en.yml"
      second = "./es.yml"
      File.open(first, "w") do |f|
        f.puts("en: ")
        f.puts("  app_name: 'Verbosefish'")
      end
      File.open(second, "w") do |f|
        f.puts("en: ")
        f.puts("  app_name: 'Verboszefish'")
      end
      Diffy::Diff.expects(:new).with("Verbosefish\n", "Verboszefish\n").returns("DIFF")
      YamldiffKeyValueError.expects(:new).with('app_name', ['en'], 'DIFF')
      result = subject.diff_yaml(first, second)
    end
  end
end

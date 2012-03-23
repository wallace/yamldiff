require "spec_helper"

describe Yamldiff do
  subject { Yamldiff }

  describe ".compare_hashes" do
    it "should be empty for equal hashes" do
      subject.compare_hashes({ a: 1 }, { a: 1 }).should be_empty
    end

    it "should be empty for nested hashes" do
      first  = { a: { b: 2 } }
      second = { a: { b: 2 } }
      subject.compare_hashes(first, second).should be_empty
    end

    it "should recognize when a key is missing" do
      first  = { a: 1, b: 2 }
      second = { a: 1 }
      result = subject.compare_hashes(first, second).first

      result.should be_an_instance_of(YamldiffKeyError)
      result.key.should eql :b
      result.context.should be_empty
    end

    it "should recognize when two keys' values are of a different type" do
      first  = { a:  1  }
      second = { a: "1" }

      result = subject.compare_hashes(first, second).first
      result.should be_an_instance_of(YamldiffKeyValueTypeError)
      result.key.should eql :a
      result.context.should be_empty
    end

    it "should recognize when two keys' values are not equal" do
      first  = { a: { b: 2 } }
      second = { a: { b: 1 } }

      result = subject.compare_hashes(first, second).first
      result.should be_an_instance_of(YamldiffKeyValueError)
      result.key.should eql :b
      result.context.should == [:a]
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

      subject.diff_yaml("./en.yml", "./es.yml").values.all? {|e| e.should eql([])}
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
      result[second].first.key.should eql("en")
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
      result[second].first.key.should eql("app_name")
      result[second].first.context.should eql(["en"])
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
      result[second].first.key.should eql("bar")
      result[second].first.context.should eql(["en", "baz"])
    end
  end
end

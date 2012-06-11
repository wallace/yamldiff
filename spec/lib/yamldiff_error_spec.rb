require "spec_helper"

describe YamldiffKeyError, "#to_s" do
  it "outputs human readable text" do
    YamldiffKeyError.new('key', ['root', 'namespace']).to_s.should == "Missing key: key in path root.namespace"
  end
end

describe YamldiffKeyValueTypeError, "#to_s" do
  it "outputs human readable text" do
    YamldiffKeyValueTypeError.new('key', ['root', 'namespace']).to_s.should == "Key value type mismatch: key in path root.namespace"
  end
end

describe YamldiffKeyValueError, "#to_s" do
  it "outputs human readable text" do
    YamldiffKeyValueError.new('key', ['root', 'namespace']).to_s.should == "Key value mismatch: key in path root.namespace"
  end

  it "outputs diff if given" do
    str1 = "foo\n"
    str2 = "bar\n"
    diff = Diffy::Diff.new(str1, str2)
    YamldiffKeyValueError.new('key', ['root', 'namespace'], diff).to_s.should == <<-OUTPUT
Key value mismatch: key in path root.namespace
Diff:
-foo
+bar
OUTPUT
  end
end

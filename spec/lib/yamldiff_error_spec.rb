require "spec_helper"

describe YamldiffKeyError, "#to_s" do
  it "outputs human readable text" do
    YamldiffKeyError.new('key', ['root', 'namespace']).to_s.should == "Missing key: root.namespace.key"
  end
end

describe YamldiffKeyValueTypeError, "#to_s" do
  it "outputs human readable text" do
    YamldiffKeyValueTypeError.new('key', ['root', 'namespace']).to_s.should == "Key value type mismatch: root.namespace.key"
  end
end

describe YamldiffKeyValueError, "#to_s" do
  it "outputs human readable text" do
    YamldiffKeyValueError.new('key', ['root', 'namespace']).to_s.should == "Key content differs: root.namespace.key"
  end

  it "outputs diff if given" do
    str1 = "foo\n"
    str2 = "bar\n"
    diff = Diffy::Diff.new(str1, str2)
    YamldiffKeyValueError.new('key', ['root', 'namespace'], diff).to_s.should == <<-OUTPUT
Key content differs: root.namespace.key
Diff:
-foo
+bar
OUTPUT
  end
end

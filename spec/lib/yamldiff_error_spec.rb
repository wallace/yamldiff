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
end

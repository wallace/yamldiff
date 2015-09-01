require "spec_helper"

describe YamldiffKeyError, "#to_s" do
  subject(:key_error) { YamldiffKeyError.new('key', ['root', 'namespace']) }

  it "outputs human readable text" do
    expect(key_error.to_s).to eql "Missing key: root.namespace.key"
  end
end

describe YamldiffKeyValueError, "#to_s" do
  context "without a diff" do
    subject(:key_value_error) { YamldiffKeyValueError.new('key', ['root', 'namespace']) }

    it "outputs human readable text" do
      expect(key_value_error.to_s).to eql "Key content differs: root.namespace.key"
    end
  end

  context "with a diff" do
    let(:diff) { Diffy::Diff.new("foo\n", "bar\n") }
    subject(:key_value_error) { YamldiffKeyValueError.new('key', ['root', 'namespace'], diff) }

    it "outputs diff if given" do
      expect(key_value_error.to_s).to eql <<-OUTPUT
Key content differs: root.namespace.key
Diff:
-foo
+bar
OUTPUT
    end
  end
end

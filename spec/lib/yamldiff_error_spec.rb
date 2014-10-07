require "spec_helper"

describe YamldiffKeyError, "#to_s" do
  subject { YamldiffKeyError.new('key', ['root', 'namespace']) }

  it "outputs human readable text" do
    expect(subject.to_s).to eql "Missing key: root.namespace.key"
  end
end

describe YamldiffKeyValueTypeError, "#to_s" do
  subject { YamldiffKeyValueTypeError.new('key', ['root', 'namespace']) }

  it "outputs human readable text" do
    expect(subject.to_s).to eql "Key value type mismatch: root.namespace.key"
  end
end

describe YamldiffKeyValueError, "#to_s" do
  context "without a diff" do
    subject { YamldiffKeyValueError.new('key', ['root', 'namespace']) }

    it "outputs human readable text" do
      expect(subject.to_s).to eql "Key content differs: root.namespace.key"
    end
  end

  context "with a diff" do
    let(:diff) { Diffy::Diff.new("foo\n", "bar\n") }
    subject { YamldiffKeyValueError.new('key', ['root', 'namespace'], diff) }

    it "outputs diff if given" do
      expect(subject.to_s).to eql <<-OUTPUT
Key content differs: root.namespace.key
Diff:
-foo
+bar
OUTPUT
    end
  end
end

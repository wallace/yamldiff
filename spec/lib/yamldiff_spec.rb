require "spec_helper"
 
describe Yamldiff do
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
end

require "spec"
require "../src/joy"

age_f = Joy::Field(Int32).new :age, :joy_spec
teeth_f = Joy::Field(Int32).new :teeth, :joy_spec

describe Joy do
  describe Joy::Map do
    it "sets and fetches" do
      map = Joy::Map.new.set age_f, 28
      map.fetch(age_f, 0).should eq 28

      
      map.fetch(teeth_f, 0).should eq 0

      map = map.set teeth_f, 32
      map.fetch(teeth_f, 0).should eq 32

      map.fetch(age_f, 0).should eq 28
    end
  end
end

require "spec"
require "../src/joy"

AGE = Joy::Field(Int32?).new :age, :joy_spec, nil
TEETH = Joy::Field(Int32?).new :teeth, :joy_spec, nil

describe Joy do
  describe Joy::Map do
    it "set and get" do
      map = Joy::Map.new.set AGE, 28
      map[AGE].should eq 28

      map[TEETH].should be_nil

      map = map.set TEETH, 32
      map.[TEETH].should eq 32

      map.[AGE].should eq 28
    end
  end
end

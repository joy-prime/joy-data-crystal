require "./spec_helper"

describe Joy do
  describe HMap do
    it "sets and fetches" do
      age_key = Joy::HKey(Int32).new :age, :joy_spec
      hmap = Joy::HMap.new.set age_key, 28
      hmap.fetch(age_key, 0).should eq 28

      teeth_key = Joy::HKey(Int32).new :teeth, :joy_spec
      hmap.fetch(teeth_key, 0).should eq 0

      hmap = hmap.set teeth_key, 32
      hmap.fetch(teeth_key, 0).should eq 32

      hmap.fetch(age_key, 0).should eq 28
    end
  end

  describe SafeBox do
    it "boxes Values and unboxes correctly when given the right type" do
      val = 42
      box : SafeBox = SafeBox.box val
      SafeBox.unbox(box, typeof(val)).should eq val
    end

    it "boxes References by reference and unboxes correctly when given the right type" do
      val = [42]
      box : SafeBox = SafeBox.box val
      unboxed_val = SafeBox.unbox box, typeof(val)
      unboxed_val.should eq val

      unboxed_val[0] = 24
      val.should eq [24]
    end
  end
end

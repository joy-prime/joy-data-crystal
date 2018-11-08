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
    describe "unbox" do
      it "unboxes Values correctly when given the right type" do
        val = 42
        box : SafeBox = SafeBox.box val
        SafeBox.unbox(box, typeof(val)).should eq val
      end

      it "unboxes References correctly and by reference when given the right type" do
        val = [42]
        box : SafeBox = SafeBox.box val
        unboxed_val = SafeBox.unbox box, typeof(val)
        unboxed_val.should eq val

        unboxed_val[0] = 24
        val.should eq [24]
      end

      it "raises when asked to unbox as a different type" do
        val = 42
        box : SafeBox = SafeBox.box val
        expect_raises TypeCastError, /Int32.*Int64/ do
          SafeBox.unbox box, Int64
        end
      end
    end

    describe "unbox?" do
      it "unboxes Values correctly when given the right type" do
        val = 42
        box : SafeBox = SafeBox.box val
        SafeBox.unbox?(box, typeof(val)).should eq val
      end

      it "returns nil when asked to unbox as a different type" do
        val = 42
        box : SafeBox = SafeBox.box val
        SafeBox.unbox?(box, Int64).should be_nil
      end
    end
  end
end

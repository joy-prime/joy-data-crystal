require "spec"
require "../src/joy_util.cr"

include JoyUtil

describe SafeBox do
  describe "unbox" do
    it "unboxes Values correctly when given the right type" do
      val = 42
      box : SafeBox = SafeBox.box val
      box.unbox(typeof(val)).should eq val
    end

    it "unboxes References correctly and by reference when given the right type" do
      val = [42]
      box : SafeBox = SafeBox.box val
      unboxed_val = box.unbox typeof(val)
      unboxed_val.should eq val

      unboxed_val[0] = 24
      val.should eq [24]
    end

    it "raises when asked to unbox as a different type" do
      val = 42
      box : SafeBox = SafeBox.box val
      expect_raises TypeCastError, /Int32.*Int64/ do
        box.unbox Int64
      end
    end
  end

  describe "unbox?" do
    it "unboxes Values correctly when given the right type" do
      val = 42
      box : SafeBox = SafeBox.box val
      box.unbox?(typeof(val)).should eq val
    end

    it "returns nil when asked to unbox as a different type" do
      val = 42
      box : SafeBox = SafeBox.box val
      box.unbox?(Int64).should be_nil
    end
  end
end

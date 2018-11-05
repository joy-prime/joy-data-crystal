require "./spec_helper"

describe Joy do
  it "sets and fetches" do
    age_key = Joy::HKey(Int32).new :age, :joy_spec
    hmap = Joy::HMap.new.set age_key, 28
    hmap.fetch(age_key, 0).should eq(28)

    teeth_key = Joy::HKey(Int32).new :teeth, :joy_spec
    hmap.fetch(teeth_key, 0).should eq(0)

    hmap = hmap.set teeth_key, 32
    hmap.fetch(teeth_key, 0).should eq(32)

    hmap.fetch(age_key, 0).should eq(28)
  end
end

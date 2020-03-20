module JoyUtil
  class SafeBox
    @@type_strings_by_type_id = {} of Int32 => String

    @type_id : Int32
    @type_string : String
    @box : Void*

    protected def initialize(clazz : Class, @box)
      @type_id = clazz.crystal_type_id
      if ts = @@type_strings_by_type_id[@type_id]?
        @type_string = ts
      else
        ts = clazz.to_s
        @@type_strings_by_type_id[@type_id] = ts
        @type_string = ts
      end
    end

    def self.box(object : T) : SafeBox forall T
      SafeBox.new(T, Box(T).box(object))
    end

    def unbox?(clazz : T.class) : T? forall T
      if @type_id == clazz.crystal_type_id
        Box(T).unbox @box
      else
        nil
      end
    end

    def unbox(clazz : T.class) : T forall T
      if @type_id == clazz.crystal_type_id
        Box(T).unbox @box
      else
        raise TypeCastError.new "tried to unbox a SafeBox of #{@type_string} as a #{T}"
      end
    end
  end
end

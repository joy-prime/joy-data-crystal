require "immutable"

# TODO: Write documentation for `Joy`
module Joy
  VERSION = "0.1.0"

  class SafeBox
    @@type_strings = {} of Int32 => String
  
    getter type_id : Int32
    getter type_string : String
    getter box : Void*
  
    def initialize(clazz : Class, box)
      @type_id = clazz.crystal_type_id
      if ts = @@type_strings[@type_id]?
        @type_string = ts
      else
        ts = clazz.to_s
        @@type_strings[@type_id] = ts
        @type_string = ts
      end
      @box = box
    end
  end
  
  class SafeBoxer(T)
    def self.box(object : T) : SafeBox
      SafeBox.new(T, Box(T).box(object))
    end
  
    def self.unbox(safe_box : SafeBox)
      if safe_box.type_id != T.crystal_type_id
        raise "Tried to unbox a SafeBox of #{safe_box.type_string} as a #{T}"
      else
        Box(T).unbox(safe_box.box)
      end
    end
  end

  struct HKey(T)
    getter name : Symbol
    getter namespace : Symbol
    getter docstring : String?

    def initialize(@name, @namespace, @docstring = nil)
    end
  end

  class HMap
    alias Storage = Immutable::Map(NamedTuple(name: Symbol, namespace: Symbol), SafeBox)

    def initialize()
      @map = Storage.new
    end

    def initialize(@map)
    end

    def internal_key(k : HKey(T)) forall T
      {name: k.name, namespace: k.namespace}
    end

    def set(k : HKey(T), v : T) : HMap forall T
      HMap.new(@map.set(internal_key(k), SafeBoxer(T).box(v)))
    end

    def fetch(k : HKey(T), default : T) : T forall T
      if box = @map[internal_key(k)]?
        SafeBoxer(T).unbox box
      else
        default
      end
    end
  end
end

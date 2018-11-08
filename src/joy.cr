require "immutable"

# TODO: Write documentation for `Joy`
module Joy
  VERSION = "0.1.0"

  class TypeMismatch < Exception
  end

  class SafeBox
    @@type_strings_by_type_id = {} of Int32 => String

    getter type_id : Int32
    getter type_string : String
    getter box : Void*

    def initialize(clazz : Class, @box)
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

    def self.unbox?(safe_box : SafeBox, clazz : T.class) : T? forall T
      if safe_box.type_id == T.crystal_type_id
        Box(T).unbox(safe_box.box)
      else
        nil
      end
    end

    def self.unbox(safe_box : SafeBox, clazz : T.class) : T forall T
      if safe_box.type_id == T.crystal_type_id
        Box(T).unbox(safe_box.box)
      else
        raise TypeCastError.new "tried to unbox a SafeBox of #{safe_box.type_string} as a #{T}"
      end
    end
  end

  struct QName
    getter name : Symbol
    getter namespace : Symbol

    def initialize(@name, @namespace)
    end
  end

  struct HKey(T)
    @@type_strings_by_type_id_by_qname = {} of QName => String

    getter qname : QName
    getter docstring : String?

    def initialize(name : Symbol, namespace : Symbol, @docstring = nil)
      @qname = QName.new name, namespace
      if existing = @@type_strings_by_type_id_by_qname[@qname]?
        raise "Duplicate HKey: already declared #{qname} as #{existing}"
      end
      @@type_strings_by_type_id_by_qname[@qname] = T.to_s
    end
  end

  class HMap
    alias Storage = Immutable::Map(QName, SafeBox)

    def initialize
      @storage = Storage.new
    end

    def initialize(@storage)
    end

    def set(k : HKey(T), v : T) : HMap forall T
      HMap.new(@storage.set(k.qname, SafeBox.box(v)))
    end

    def fetch(k : HKey(T), default : T) : T forall T
      if box = @storage[k.qname]?
        SafeBox.unbox box, T
      else
        default
      end
    end
  end
end

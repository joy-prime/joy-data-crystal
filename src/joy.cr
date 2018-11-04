require "immutable"

# TODO: Write documentation for `Joy`
module Joy
  VERSION = "0.1.0"

  struct HKey(T)
    getter name : Symbol
    getter namespace : Symbol
    getter docstring : String?

    def initialize(@name, @namespace, @docstring = nil)
    end
  end

  class HMap
    alias Storage = Immutable::Map(NamedTuple(name: Symbol, namespace: Symbol), Pointer(Void))

    def initialize()
      @map = Storage.new
    end

    def initialize(@map)
    end

    def internal_key(k : HKey(T)) forall T
      {name: k.name, namespace: k.namespace}
    end

    def set(k : HKey(T), v : T) : HMap forall T
      HMap.new(@map.set(internal_key(k), Box(T).box(v)))
    end

    def fetch(k : HKey(T), default : T) : T forall T
      if void_ptr = @map[internal_key(k)]?
        Box(T).unbox void_ptr
      else
        default
      end
    end
  end
end

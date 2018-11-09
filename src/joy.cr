require "immutable"

# TODO: Write documentation for `Joy`
module Joy
  VERSION = "0.1.0"

  struct Name
    getter symbol : Symbol
    getter namespace : Symbol

    def initialize(@symbol, @namespace)
    end
  end

  module Data
  end

  struct ::Value
    include Joy::Data
  end
  
  class ::Reference
    include Joy::Data
  end

  class Field(T)
    @@type_strings_by_name = {} of Name => String

    getter name : Name
    getter docstring : String?

    def initialize(symbol, namespace, @docstring = nil)
      @name = Name.new(symbol, namespace)
      if existing = @@type_strings_by_name[@name]?
        raise "Duplicate field name: already declared #{name} as #{existing}"
      end
      @@type_strings_by_name[@name] = T.to_s
    end
  end

  class Map
    alias Storage = Immutable::Map(Name, Data)

    def initialize
      @storage = Storage.new
    end

    def initialize(@storage)
    end

    def set(f : Field(T), v : T) : Map forall T
      Map.new(@storage.set f.name, v)
    end

    def fetch(k : Field(T), default : T) : T forall T
      if data = @storage[k.name]?
        data.as(T)
      else
        default
      end
    end
  end
end


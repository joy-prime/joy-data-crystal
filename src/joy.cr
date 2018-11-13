require "immutable"

# TODO: Write documentation for `Joy`
module Joy
  VERSION = "0.1.0"

  struct Name
    getter symbol : Symbol
    getter namespace : Symbol

    def initialize(@symbol, @namespace)
    end

    def to_s(io : IO)
      io.puts "Name(#{symbol}, #{namespace})"
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
    getter default : T

    def initialize(symbol, namespace, @default)
      @name = Name.new(symbol, namespace)
      if existing = @@type_strings_by_name[@name]?
        raise "Duplicate field name: already declared #{name} as #{existing}"
      end
      @@type_strings_by_name[@name] = T.to_s
    end

    def to_s(io : IO)
      io.puts "Field(#{@@type_strings_by_name[@name]})(#{name.symbol} #{name.namespace})"
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

    # Returns the value associated with *field*, or, when not found, the field's default value.
    def [](field : Field(T)) : T forall T
      @storage.fetch field.name do |key|
        field.default
      end
    end

    # def has_field?(field : Field(T)) : Bool
    #  data = @storage.fetch field.name do
    #    break false
    #  end
    #  true
    #end
  end

  class Mapish
    getter map : Map

    def initialize(@map)
    end
  end
end

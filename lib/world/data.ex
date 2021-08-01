defmodule ElixirRPG.World.Data do
  use TypedStruct

  typedstruct do
    field(:name, String.t(), default: "world")
    field(:clock, pid(), default: nil)
    field(:target_tick_rate, integer(), default: 0)

    field(:systems, list(), default: [])
    field(:entities, list(), default: [])
  end
end
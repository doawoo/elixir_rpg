defmodule ElixirRPG.Component.Poison do
  use TypedStruct

  typedstruct do
    field(:duration, Integer.t(), default: 10)
    field(:dmg_per_tick, Integer.t(), default: 1)
  end
end

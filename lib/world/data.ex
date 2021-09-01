defmodule ElixirRPG.World.Data do
  use TypedStruct

  typedstruct do
    field(:name, atom(), default: :global)
    field(:clock, pid(), default: nil)
    field(:target_tick_rate, integer(), default: 0)

    field(:systems, list(), default: [])

    field(:pending_input, World.Input.t(), default: nil)
  end
end

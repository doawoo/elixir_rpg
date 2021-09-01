defmodule ElixirRPG.World.Input do
  use TypedStruct

  typedstruct do
    field(:target_character, pid(), enforce: true)
    field(:input_type, atom(), enforce: true)
    field(:input_paramters, map(), enforce: true)
  end
end

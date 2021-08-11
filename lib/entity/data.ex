defmodule ElixirRPG.Entity.Data do
  use TypedStruct

  typedstruct do
    field :world_name, atom(), default: :global
    field :components, map(), default: %{}
  end
end

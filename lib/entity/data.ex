defmodule ElixirRPG.Entity.Data do
  use TypedStruct

  typedstruct do
    field :name, String.t(), default: "untitled_entity"
    field :world_name, atom(), default: :global
    field :components, map(), default: %{}
  end
end

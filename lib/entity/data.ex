defmodule ElixirRPG.Entity.Data do
  use TypedStruct

  typedstruct do
    field :name, String.t(), default: "untitled_entity"
    field :world_ref, pid(), default: nil
    field :components, Map.t(), default: %{}
  end
end

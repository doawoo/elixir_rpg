defmodule ElixirRPG.Entity.Data do
  use TypedStruct

  typedstruct do
    field(:name, String.t(), default: "untitled_entity")
    field(:components, Map.t(), default: %{})
  end
end

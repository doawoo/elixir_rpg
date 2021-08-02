defmodule ElixirRPG.Component.ActorStats do
  use TypedStruct

  typedstruct do
    field(:hp, Integer.t(), default: 100)
    field(:mp, Integer.t(), default: 20)
    field(:dead, boolean(), default: false)
  end
end

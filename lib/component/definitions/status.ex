use ElixirRPG.DSL.Component

defcomponent Status do
  @type status :: {atom(), number(), number()}
  member :status_list, []
end

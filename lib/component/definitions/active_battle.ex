use ElixirRPG.DSL.Component

defcomponent ActiveBattle do
  member :ready, false
  member :frozen, false
  member :atb_value, 0.0
end

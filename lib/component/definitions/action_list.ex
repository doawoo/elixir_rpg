use ElixirRPG.DSL.Component

defcomponent ActionList do
  member :actions, []
  member :can_act, false
  member :take_player_input, false
end

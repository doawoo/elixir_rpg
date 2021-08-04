use ElixirRPG.DSL.Entity

alias ElixirRPG.Component.ActorStats

defentity Player do
  name "The Player"
  component ActorStats, %{hp: 150}
end

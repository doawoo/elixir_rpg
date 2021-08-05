use ElixirRPG.DSL.Entity

defentity Player do
  name "The Player"
  component ActorStats, %{hp: 150}
end

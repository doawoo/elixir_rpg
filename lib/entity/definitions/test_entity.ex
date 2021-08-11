use ElixirRPG.DSL.Entity

defentity Player do
  component ActorStats, %{hp: 150}
  component ActorName, %{name: "Unknown"}
end

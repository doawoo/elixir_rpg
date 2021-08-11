use ElixirRPG.DSL.Entity

defentity Flan do
  component ActorStats, %{
    hp: 75,
    mp: 183,
    speed: 17,
    strength: 23
  }

  component ActorName, %{name: "Flan"}

  component NPCBrain
  component ActiveBattle
end

use ElixirRPG.DSL.Entity

defentity Flan do
  name "Flan"

  component ActorStats, %{
    hp: 75,
    mp: 183,
    speed: 17,
    strength: 23
  }

  component NPCBrain
  component ActiveBattle
end

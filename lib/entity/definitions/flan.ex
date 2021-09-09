use ElixirRPG.DSL.Entity

defentity Flan do
  component ActorStats, %{
    max_hp: 75,
    hp: 75,
    max_mp: 183,
    mp: 183,
    speed: 17,
    strength: 23
  }

  component Sprite, %{sprite_name: "flan.jpg"}

  component ActorName, %{name: "Flan"}

  component NPCBrain
  component ActiveBattle
end

use ElixirRPG.DSL.Entity

defentity Frowny do
  component DemoStats, %{
    max_hp: 75,
    hp: 75,
    max_mp: 183,
    mp: 183,
    speed: 5
  }

  component Sprite, %{sprite_name: "enemy/frowny.png", full_image: true}

  component ActorName, %{name: "Frowny"}

  component NPCBrain, %{brain_name: "frowny"}
  component ActiveBattle

  component AnimationMod
end

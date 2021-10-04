use ElixirRPG.DSL.Entity

defentity Smiley do
  component DemoStats, %{
    max_hp: 75,
    hp: 75,
    max_mp: 183,
    mp: 183,
    speed: 5
  }

  component Status

  component Sprite, %{sprite_name: "enemy/smiley.png", full_image: true}

  component ActorName, %{name: "Smiley"}

  component NPCBrain, %{brain_name: "smiley"}
  component ActiveBattle

  component AnimationMod
end

use ElixirRPG.DSL.Entity

defentity Smiley do
  component DemoStats, %{
    max_hp: 20,
    hp: 20,
    max_mp: 200,
    mp: 200,
    speed: 5
  }

  component Status

  component Sprite, %{sprite_name: "enemy/smiley.png", full_image: true}

  component ActorName, %{name: "Smiley"}

  component NPCBrain, %{brain_name: "smiley"}
  component ActiveBattle

  component AnimationMod

  component Targetable, %{actions_enabled: [:shock, :burn, :attack]}
end

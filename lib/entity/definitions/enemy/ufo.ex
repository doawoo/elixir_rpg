use ElixirRPG.DSL.Entity

defentity UFO do
  component DemoStats, %{
    max_hp: 150,
    hp: 150,
    max_mp: 200,
    mp: 200,
    speed: 7
  }

  component Status

  component Sprite, %{sprite_name: "enemy/ufo.png", full_image: true}

  component ActorName, %{name: "UFO"}

  component NPCBrain, %{brain_name: "ufo"}
  component ActiveBattle

  component AnimationMod

  component Targetable, %{actions_enabled: [:shock, :burn, :attack]}
end

use ElixirRPG.DSL.Entity

defentity UFO do
  component DemoStats, %{
    max_hp: 175,
    hp: 175,
    max_mp: 400,
    mp: 400,
    speed: 10
  }

  component Status

  component Sprite, %{sprite_name: "enemy/ufo.png", full_image: true}

  component ActorName, %{name: "UFO"}

  component NPCBrain, %{brain_name: "ufo"}
  component ActiveBattle

  component AnimationMod

  component Targetable, %{actions_enabled: [:shock, :burn, :attack]}
end

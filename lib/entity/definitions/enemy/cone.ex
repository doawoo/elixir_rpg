use ElixirRPG.DSL.Entity

defentity Cone do
  component DemoStats, %{
    max_hp: 45,
    hp: 1,
    max_mp: 183,
    mp: 183,
    speed: 5
  }

  component Status

  component Sprite, %{sprite_name: "enemy/cone.png", full_image: true}

  component ActorName, %{name: "Cone"}

  component NPCBrain, %{brain_name: "cone"}
  component ActiveBattle

  component AnimationMod

  component Targetable, %{actions_enabled: [:shock, :burn, :attack]}

  component Enemy
end

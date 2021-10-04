use ElixirRPG.DSL.Entity

defentity Cylinder do
  component DemoStats, %{
    max_hp: 75,
    hp: 75,
    max_mp: 183,
    mp: 183,
    speed: 5
  }

  component Status

  component Sprite, %{sprite_name: "enemy/cylinder.png", full_image: true}

  component ActorName, %{name: "Cylinder"}

  component NPCBrain, %{brain_name: "cylinder"}
  component ActiveBattle

  component AnimationMod

  component Targetable, %{actions_enabled: [:shock, :burn, :attack]}
end

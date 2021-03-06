use ElixirRPG.DSL.Entity

defentity Walker do
  component DemoStats, %{
    max_hp: 10,
    hp: 10,
    max_mp: 20,
    mp: 20,
    speed: 40
  }

  component Status

  component Sprite, %{sprite_name: "enemy/walker.png", full_image: true}

  component ActorName, %{name: "Walker"}

  component NPCBrain, %{brain_name: "walker"}
  component ActiveBattle

  component AnimationMod

  component Targetable, %{actions_enabled: [:shock, :burn, :attack]}

  component Enemy
end

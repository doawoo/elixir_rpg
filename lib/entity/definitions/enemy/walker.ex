use ElixirRPG.DSL.Entity

defentity Walker do
  component DemoStats, %{
    max_hp: 50,
    hp: 50,
    max_mp: 20,
    mp: 20,
    speed: 20
  }

  component Status

  component Sprite, %{sprite_name: "enemy/walker.png", full_image: true}

  component ActorName, %{name: "Walker"}

  component NPCBrain, %{brain_name: "walker"}
  component ActiveBattle

  component AnimationMod

  component Targetable, %{actions_enabled: [:shock, :burn, :attack]}
end

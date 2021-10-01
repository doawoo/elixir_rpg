use ElixirRPG.DSL.Entity

defentity Walker do
  component DemoStats, %{
    max_hp: 75,
    hp: 75,
    max_mp: 183,
    mp: 183,
    speed: 5
  }

  component Sprite, %{sprite_name: "enemy/walker.png", full_image: true}

  component ActorName, %{name: "Walker"}

  component NPCBrain, %{brain_name: "walker"}
  component ActiveBattle

  component AnimationMod
end

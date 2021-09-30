use ElixirRPG.DSL.Entity

defentity Cone do
  component DemoStats, %{
    max_hp: 75,
    hp: 75,
    max_mp: 183,
    mp: 183,
    speed: 5
  }

  component Sprite, %{sprite_name: "flan.jpg", full_image: true}

  component ActorName, %{name: "Cone"}

  # component NPCBrain, %{brain_name: "flan"}
  component ActiveBattle

  component AnimationMod
end

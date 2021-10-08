use ElixirRPG.DSL.Entity

defentity Frowny do
  component DemoStats, %{
    max_hp: 20,
    hp: 20,
    max_mp: 200,
    mp: 200,
    speed: 5
  }

  component Status

  component Sprite, %{sprite_name: "enemy/frowny.png", full_image: true}

  component ActorName, %{name: "Frowny"}

  component NPCBrain, %{brain_name: "frowny"}
  component ActiveBattle

  component AnimationMod

  component Targetable, %{actions_enabled: [:shock, :burn, :attack]}
end

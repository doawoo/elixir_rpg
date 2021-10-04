use ElixirRPG.DSL.Entity

defentity Cat do
  component ActorName, %{name: "Cat"}
  component Sprite, %{sprite_name: "char/cat/normal.png", base_sprite_dir: "char/cat"}
  component GridPosition, %{index: 7}

  component ActionList, %{actions: [{:intent, :attack}, {:intent, :burn}, :shock]}

  component DemoStats, %{
    hp: 50,
    max_hp: 50,
    mp: 30,
    max_mp: 30,
    speed: 12
  }

  component Status

  component ActiveBattle
  component AnimationMod

  component Targetable, %{actions_enabled: [:coffee, :black_tea, :green_tea]}
end

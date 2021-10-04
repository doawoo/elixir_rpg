use ElixirRPG.DSL.Entity

defentity SodaBot do
  component ActorName, %{name: "SodaBot"}
  component Sprite, %{sprite_name: "char/soda/normal.png", base_sprite_dir: "char/soda"}
  component GridPosition, %{index: 9}

  component ActionList, %{
    actions: [{:intent, :coffee}, {:intent, :green_tea}, {:intent, :black_tea}]
  }

  component DemoStats, %{
    hp: 25,
    max_hp: 25,
    mp: 40,
    max_mp: 40,
    speed: 7
  }

  component Status

  component ActiveBattle
  component AnimationMod

  component Targetable, %{actions_enabled: [:coffee, :black_tea, :green_tea]}
end

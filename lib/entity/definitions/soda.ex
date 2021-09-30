use ElixirRPG.DSL.Entity

defentity SodaBot do
  component ActorName, %{name: "SodaBot"}
  component Sprite, %{sprite_name: "char/soda/normal.png", base_sprite_dir: "char/soda"}
  component GridPosition, %{index: 9}

  component ActionList, %{actions: [:coffee, :green_tea, :black_tea]}

  component DemoStats, %{
    hp: 25,
    max_hp: 25,
    mp: 40,
    max_mp: 40,
    speed: 10
  }

  component ActiveBattle
  component AnimationMod
end
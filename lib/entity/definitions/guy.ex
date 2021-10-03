use ElixirRPG.DSL.Entity

defentity Guy do
  component ActorName, %{name: "Guy"}
  component Sprite, %{sprite_name: "char/guy/normal.png", base_sprite_dir: "char/guy"}
  component GridPosition, %{index: 8}

  component ActionList, %{actions: [:dance]}

  component DemoStats, %{
    hp: 10,
    max_hp: 10,
    mp: 10,
    max_mp: 10,
    speed: 10
  }

  component ActiveBattle
  component AnimationMod
end

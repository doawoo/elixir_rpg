use ElixirRPG.DSL.Entity

defentity Guy do
  component ActorName, %{name: "Guy"}
  component Sprite, %{sprite_name: "char/guy/normal.png", base_sprite_dir: "char/guy"}
  component GridPosition, %{index: 8}

  component ActionList, %{actions: [:dance]}

  component DemoStats, %{
    hp: 10,
    max_hp: 10,
    mp: 5,
    max_mp: 5,
    speed: 15
  }

  component Status, %{to_be_added: [{:coffee_up, 0.0}]}

  component ActiveBattle
  component AnimationMod

  component Targetable, %{actions_enabled: [:coffee, :black_tea, :green_tea]}
end

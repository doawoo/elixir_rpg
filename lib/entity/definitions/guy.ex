use ElixirRPG.DSL.Entity

defentity Guy do
  component ActorName, %{name: "Guy"}
  component Sprite, %{sprite_name: "char/guy/guy.png"}
  component GridPosition, %{index: 8}

  component ActionList, %{actions: [:dance]}

  component DemoStats, %{
    hp: 20,
    max_hp: 20,
    mp: 10,
    max_mp: 20,
    speed: 10
  }

  component ActiveBattle
  component AnimationMod
end

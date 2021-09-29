use ElixirRPG.DSL.Entity

defentity Drink do
  component ActorName, %{name: "Drink"}
  component Sprite, %{sprite_name: "char/drink/drink.png"}
  component GridPosition, %{index: 9}

  component ActionList, %{actions: [:coffee, :tea]}

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

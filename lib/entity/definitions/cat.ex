use ElixirRPG.DSL.Entity

defentity Cat do
  component ActorName, %{name: "Cat"}
  component Sprite, %{sprite_name: "char/cat/cat.png"}
  component GridPosition, %{index: 7}

  component ActionList, %{actions: [:attack, :flame, :roast]}

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

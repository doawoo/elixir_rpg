use ElixirRPG.DSL.Entity

defentity DemoA do
  component ActorName, %{name: "Demo Character A"}
  component Sprite, %{sprite_name: "bot.png"}

  component PlayerInput
  component ActionList, %{actions: [:dance]}

  component DemoStats, %{
    hp: 20,
    max_hp: 20,
    mp: 10,
    max_mp: 20,
    speed: 5
  }

  component ActiveBattle
  component AnimationMod
end

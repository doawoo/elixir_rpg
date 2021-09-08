use ElixirRPG.DSL.Entity

defentity Zidane do
  component ActorStats, %{
    hp: 105,
    mp: 36,
    speed: 23,
    strength: 23
  }

  component Sprite, %{sprite_name: "zidane.png"}

  component ActorName, %{name: "Zidane"}

  component ActiveBattle
  component PlayerInput
end

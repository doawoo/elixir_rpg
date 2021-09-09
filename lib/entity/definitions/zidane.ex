use ElixirRPG.DSL.Entity

defentity Zidane do
  component ActorStats, %{
    max_hp: 100,
    hp: 100,
    max_mp: 36,
    mp: 36,
    speed: 23,
    strength: 23
  }

  component Sprite, %{sprite_name: "zidane.png"}

  component ActorName, %{name: "Zidane"}

  component ActiveBattle
  component PlayerInput
end

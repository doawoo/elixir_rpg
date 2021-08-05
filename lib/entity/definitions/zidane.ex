use ElixirRPG.DSL.Entity

defentity Zidane do
  name "Zidane"

  component ActorStats, %{
    hp: 105,
    mp: 36,
    speed: 23,
    strength: 23
  }

  component ActiveBattle
  component PlayerInput
end
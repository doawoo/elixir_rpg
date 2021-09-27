use ElixirRPG.DSL.Entity

defentity BotB do
  component Sprite, %{sprite_name: "bot.png"}

  component ActorName, %{name: "Bot_B"}

  component PlayerInput

  component GridPosition, %{index: 8}

  component ActiveBattle
  component ActorStats

  component AnimationMod
end

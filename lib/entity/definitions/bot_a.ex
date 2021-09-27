use ElixirRPG.DSL.Entity

defentity BotA do
  component Sprite, %{sprite_name: "bot.png"}

  component ActorName, %{name: "Bot_A"}

  component PlayerInput

  component GridPosition, %{index: 7}

  component ActiveBattle
  component ActorStats

  component AnimationMod
end

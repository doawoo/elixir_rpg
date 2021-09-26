use ElixirRPG.DSL.Entity

defentity BotC do
  component Sprite, %{sprite_name: "bot.png"}

  component ActorName, %{name: "Bot_C"}

  component PlayerInput

  component GridPosition, %{index: 9}

  component AnimationMod
end

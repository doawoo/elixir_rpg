use ElixirRPG.DSL.System

defsystem PlayerInput do
  require Logger

  name "PlayerInputSystem"

  wants ActorName
  wants ActorStats
  wants PlayerInput
  wants ActiveBattle

  on_tick do
    _ = frontend_pid
    can_move? = get_component_data(ActiveBattle, :ready)
    set_component_data(PlayerInput, :enabled, can_move?)

    # Are we able to move, is there input pending, and is it for us?
    with true <- can_move?,
         %{} = input_map <- ElixirRPG.get_pending_input(world_name),
         true <- Map.has_key?(input_map, entity) do
      input = input_map[entity]
      ElixirRPG.clear_input(world_name, entity)
      Logger.info("Consume input from #{inspect(entity)} -- #{inspect(input)}")
    else
      _ -> :ok
    end
  end
end

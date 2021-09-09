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

    # 1. Able to move?
    # 2. Have an input to consume?
    # 3. Input is for us?
    with true <- can_move?,
         %{} = input_map <- ElixirRPG.get_pending_input(world_name),
         true <- Map.has_key?(input_map, entity) do
      # Consume the input and execute the action
      # Clear the input from the input server
    else
      _ -> :ok
    end
  end
end

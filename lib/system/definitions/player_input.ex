use ElixirRPG.DSL.System

defsystem PlayerInput do
  require Logger

  alias ElixirRPG.Entity
  alias ElixirRPG.World.Input

  name "PlayerInputSystem"

  wants ActorName
  wants DemoStats
  wants PlayerInput
  wants ActiveBattle
  wants ActionList

  on_tick do
    _ = delta_time
    _ = frontend_pid

    can_move? = get_component_data(ActiveBattle, :ready)
    set_component_data(PlayerInput, :enabled, can_move?)
    set_component_data(ActionList, :can_act, can_move?)

    # Are we able to move, is there input pending, and is it for us?
    with true <- can_move?,
         %{} = input_map <- ElixirRPG.get_pending_input(world_name),
         true <- Map.has_key?(input_map, entity) do
      input = input_map[entity]
      ElixirRPG.clear_input(world_name, entity)
      Logger.info("Consume input from #{inspect(entity)} -- #{inspect(input)}")
      process_input(input, entity)
    else
      _ -> :ok
    end
  end

  defp process_input(%Input{} = input, entity) do
    action_list = Entity.get_component(entity, ActionList).actions
    action = input.input_paramters.action_name |> String.to_existing_atom()
    if Enum.member?(action_list, action) do
      Entity.set_component_data(entity, ActiveBattle, :ready, false)
      Entity.set_component_data(entity, ActiveBattle, :atb_value, 0.0)

      case action do
        :dance -> do_dance(entity)
      end
    end
  end

  defp do_dance(entity) do
    ElixirRPG.RuntimeSystems.AnimateModSystem.add_animation(entity, "animate__tada", 15)
  end
end

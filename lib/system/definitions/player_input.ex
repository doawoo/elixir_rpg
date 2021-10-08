use ElixirRPG.DSL.System

defsystem PlayerInput do
  require Logger

  alias ElixirRPG.Entity
  alias ElixirRPG.Action
  alias ElixirRPG.Action.ActionTypes
  alias ElixirRPG.World.Input

  name "PlayerInputSystem"

  wants ActorName
  wants DemoStats
  wants ActiveBattle
  wants ActionList

  on_tick do
    _ = delta_time
    _ = frontend_pid

    can_move? = get_component_data(ActiveBattle, :ready)
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
    action_list = Entity.get_component(entity, ActionList).actions |> Enum.map(&get_action/1)
    action = input.input_paramters.action_name |> String.to_existing_atom()

    if Enum.member?(action_list, action) do
      Entity.set_component_data(entity, ActiveBattle, :ready, false)
      Entity.set_component_data(entity, ActiveBattle, :atb_value, 0.0)

      case action do
        :dance -> do_dance(entity)
        :attack -> do_attack(entity, input.input_paramters.target)
        :coffee -> do_coffee_cast(entity, input.input_paramters.target)
        :green_tea -> do_green_tea_cast(entity, input.input_paramters.target)
        :black_tea -> do_black_tea_cast(entity, input.input_paramters.target)
      end
    end
  end

  defp do_dance(entity) do
    ElixirRPG.RuntimeSystems.AnimateModSystem.add_animation(entity, "animate__tada", 15.0)
    ElixirRPG.RuntimeSystems.SpecialSpriteSystem.set_sprite_override(entity, "dance.gif", 2.05)
  end

  defp do_attack(entity, target) do
    attacker_stats = Entity.get_component(entity, DemoStats)
    atk_action = ActionTypes.physical_damage(target, attacker_stats.attack_power, false)

    Action.execute(atk_action)
    Entity.set_component_data(entity, ActiveBattle, :atb_value, 0.0)
  end

  defp do_coffee_cast(entity, target) do
    casting_delay = 2.0
    Entity.set_component_data(entity, ActiveBattle, :atb_value, 0.0)
    Entity.set_component_data(entity, DemoStats, :casting, true)
    Entity.set_component_data(entity, DemoStats, :casting_target, target)
    Entity.set_component_data(entity, DemoStats, :casting_data, :coffee_up)
    Entity.set_component_data(entity, DemoStats, :casting_delay, casting_delay)
  end

  defp do_green_tea_cast(entity, target) do
    Entity.set_component_data(entity, ActiveBattle, :atb_value, 0.0)
  end

  defp do_black_tea_cast(entity, target) do
    Entity.set_component_data(entity, ActiveBattle, :atb_value, 0.0)
  end

  defp get_action({:intent, a}), do: a
  defp get_action(a), do: a
end

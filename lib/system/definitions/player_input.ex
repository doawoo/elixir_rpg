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
      process_input(input, world_name, entity)
    else
      _ -> :ok
    end
  end

  defp process_input(%Input{} = input, world_name, entity) do
    action_list = Entity.get_component(entity, ActionList).actions |> Enum.map(&get_action/1)
    action = input.input_paramters.action_name |> String.to_existing_atom()

    if Enum.member?(action_list, action) do
      Entity.set_component_data(entity, ActiveBattle, :ready, false)
      Entity.set_component_data(entity, ActiveBattle, :atb_value, 0.0)

      case action do
        :dance -> do_dance(entity)
        :shock -> do_shock(entity, world_name)
        :burn -> do_burn(entity, input.input_paramters.target)
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

  defp do_shock(entity, world_name) do
    required_mp = 12
    current_mp = Entity.get_component(entity, DemoStats).mp

    if Entity.get_component(entity, DemoStats).mp >= required_mp do
      enemies = ElixirRPG.Entity.EntityStore.get_entities_with([Enemy], world_name)
      Enum.each(enemies, fn e ->
        ActionTypes.give_status(e, :shock) |> Action.execute()
      end)
      Entity.set_component_data(entity, DemoStats, :mp, current_mp - required_mp)
    end
  end

  defp do_burn(entity, target) do
    required_mp = 12
    current_mp = Entity.get_component(entity, DemoStats).mp

    if Entity.get_component(entity, DemoStats).mp >= required_mp do
      casting_delay = 2.0
      burn_action = ActionTypes.give_status(target, :burn)

      Entity.set_component_data(entity, ActiveBattle, :atb_value, 0.0)
      Entity.set_component_data(entity, DemoStats, :casting, true)
      Entity.set_component_data(entity, DemoStats, :casting_data, burn_action)
      Entity.set_component_data(entity, DemoStats, :casting_delay, casting_delay)

      Entity.set_component_data(entity, DemoStats, :mp, current_mp - required_mp)
    end
  end

  defp do_coffee_cast(entity, target) do
    required_mp = 7
    current_mp = Entity.get_component(entity, DemoStats).mp

    if Entity.get_component(entity, DemoStats).mp >= required_mp do
      casting_delay = 2.0
      coffee_action = ActionTypes.give_status(target, :coffee_up)

      Entity.set_component_data(entity, ActiveBattle, :atb_value, 0.0)
      Entity.set_component_data(entity, DemoStats, :casting, true)
      Entity.set_component_data(entity, DemoStats, :casting_data, coffee_action)
      Entity.set_component_data(entity, DemoStats, :casting_delay, casting_delay)

      Entity.set_component_data(entity, DemoStats, :mp, current_mp - required_mp)
    end
  end

  defp do_green_tea_cast(entity, target) do
    required_mp = 15
    current_mp = Entity.get_component(entity, DemoStats).mp

    if current_mp >= required_mp do
      Entity.set_component_data(entity, ActiveBattle, :atb_value, 0.0)

      casting_delay = 3.0
      mp_action = ActionTypes.restore_mp(target, 15)
      Entity.set_component_data(entity, DemoStats, :casting, true)
      Entity.set_component_data(entity, DemoStats, :casting_data, mp_action)
      Entity.set_component_data(entity, DemoStats, :casting_delay, casting_delay)

      Entity.set_component_data(entity, DemoStats, :mp, current_mp - required_mp)
    end
  end

  defp do_black_tea_cast(entity, target) do
    required_mp = 15
    current_mp = Entity.get_component(entity, DemoStats).mp

    if current_mp >= required_mp do
      Entity.set_component_data(entity, ActiveBattle, :atb_value, 0.0)

      casting_delay = 3.0
      heal_action = ActionTypes.heal(target, 15)
      Entity.set_component_data(entity, DemoStats, :casting, true)
      Entity.set_component_data(entity, DemoStats, :casting_data, heal_action)
      Entity.set_component_data(entity, DemoStats, :casting_delay, casting_delay)

      Entity.set_component_data(entity, DemoStats, :mp, current_mp - required_mp)
    end
  end

  defp get_action({:intent, a}), do: a
  defp get_action(a), do: a
end

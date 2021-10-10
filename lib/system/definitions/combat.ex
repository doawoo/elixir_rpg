use ElixirRPG.DSL.System

defsystem CombatSystem do
  require Logger

  alias ElixirRPG.ComponentTypes
  alias ElixirRPG.Entity
  alias ElixirRPG.Action

  alias ElixirRPG.RuntimeSystems.StatusEffectSystem
  alias ElixirRPG.RuntimeSystems.AnimateModSystem

  name "CombatSystem"

  wants ActorName
  wants DemoStats
  wants AnimationMod

  on_tick do
    _ = frontend_pid
    _ = delta_time
    # name = get_component_data(ActorName, :name)

    # pop actions from the queue and process them until we run out
    first_action = Entity.pop_action(entity)
    process_action(entity, first_action, world_name)
  end

  defp process_action(_entity_pid, :empty, _world_name), do: :ok

  defp process_action(entity_pid, %Action{action_type: :dmg_phys} = action, _world_name) do
    case Entity.get_component(entity_pid, DemoStats) do
      %ComponentTypes.DemoStats{} = stats ->
        dmg_delt = action.payload.power
        new_hp = stats.hp - dmg_delt

        if new_hp <= 0 do
          Entity.set_component_data(entity_pid, DemoStats, :hp, 0)
          Entity.set_component_data(entity_pid, DemoStats, :dead, true)

          AnimateModSystem.add_animation(
            entity_pid,
            "animate__rotateOut animate__faster"
          )
        else
          Entity.set_component_data(entity_pid, DemoStats, :hp, new_hp)
          Entity.set_component_data(entity_pid, DemoStats, :just_took_damage, true)

          AnimateModSystem.add_animation(
            entity_pid,
            "animate__jello animate__faster"
          )
        end

      _ ->
        nil
    end
  end

  defp process_action(entity, %Action{action_type: :healing, payload: payload}, _world_name) do
    current_stats = Entity.get_component(entity, DemoStats)
    new_hp = min(current_stats.max_hp, current_stats.hp + payload.amount)
    Entity.set_component_data(entity, DemoStats, :hp, new_hp)
  end

  defp process_action(entity, %Action{action_type: :restore_mp, payload: payload}, _world_name) do
    current_stats = Entity.get_component(entity, DemoStats)
    new_hp = min(current_stats.max_mp, current_stats.mp + payload.amount)
    Entity.set_component_data(entity, DemoStats, :mp, new_hp)
  end

  defp process_action(entity, %Action{action_type: :give_status, payload: %{effect: effect}}, _world_name) do
    StatusEffectSystem.add_status_to_entity(entity, effect)
  end

  defp process_action(_entity, %Action{action_type: :spawn, payload: %{set: {spawn1, spawn2}}}, world_name) do
    world = Process.whereis(world_name)
    ElixirRPG.World.add_entity(world, spawn1);
    ElixirRPG.World.add_entity(world, spawn2);
  end

  defp process_action(entity_pid, %Action{} = unknown_action, _world_name) do
    Logger.warn("Unknown action: #{inspect(entity_pid)} #{inspect(unknown_action)}")
  end
end

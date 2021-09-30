use ElixirRPG.DSL.System

defsystem CombatSystem do
  require Logger

  alias ElixirRPG.ComponentTypes
  alias ElixirRPG.Entity
  alias ElixirRPG.Action

  alias ElixirRPG.RuntimeSystems.AnimateModSystem

  name "CombatSystem"

  wants ActorName
  wants DemoStats
  wants AnimationMod

  on_tick do
    _ = world_name
    _ = frontend_pid
    _ = delta_time
    # name = get_component_data(ActorName, :name)

    # pop actions from the queue and process them until we run out
    first_action = Entity.pop_action(entity)
    process_action(entity, first_action)
  end

  defp process_action(_entity_pid, :empty), do: :ok

  defp process_action(entity_pid, %Action{action_type: :dmg_phys} = action) do
    case Entity.get_component(entity_pid, DemoStats) do
      %ComponentTypes.DemoStats{} = stats ->
        dmg_delt = action.payload.power - stats.defense
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

  defp process_action(entity_pid, %Action{} = unknown_action) do
    Logger.warn("Unknown action: #{inspect(entity_pid)} #{inspect(unknown_action)}")
  end
end

use ElixirRPG.DSL.System

defsystem CombatSystem do
  require Logger

  alias ElixirRPG.ComponentTypes
  alias ElixirRPG.Entity
  alias ElixirRPG.Action

  name "CombatSystem"

  wants ActorName

  on_tick do
    _ = world_name
    _ = frontend_pid
    # name = get_component_data(ActorName, :name)

    # pop actions from the queue and process them until we run out
    first_action = Entity.pop_action(entity)
    process_action(entity, first_action)
  end

  defp process_action(_entity_pid, :empty), do: :ok

  defp process_action(entity_pid, %Action{action_type: :dmg_phys} = action) do
    case Entity.get_component(entity_pid, ActorStats) do
      %ComponentTypes.ActorStats{} = stats ->
        dmg_delt = action.payload.power - stats.defense
        new_hp = stats.hp - dmg_delt

        if new_hp <= 0 do
          Entity.set_component_data(entity_pid, ActorStats, :hp, 0)
          Entity.set_component_data(entity_pid, ActorStats, :dead, true)
        else
          Entity.set_component_data(entity_pid, ActorStats, :hp, new_hp)
        end

      _ ->
        nil
    end
  end

  defp process_action(entity_pid, %Action{} = unknown_action) do
    Logger.warn("Unknown action: #{inspect(entity_pid)} #{inspect(unknown_action)}")
  end
end

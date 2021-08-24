use ElixirRPG.DSL.System

defsystem CombatSystem do
  require Logger
  alias ElixirRPG.Action

  name "CombatSystem"

  wants ActorName

  on_tick do
    _world = world_name
    # name = get_component_data(ActorName, :name)

    # pop actions from the queue and process them until we run out
    first_action = GenServer.call(entity, :pop_action)
    process_action(entity, first_action)
  end

  defp process_action(_entity_pid, :empty), do: :ok

  defp process_action(entity_pid, %Action{} = action) do
    Logger.info("Executing action: #{inspect(entity_pid)} #{inspect(action)}")
  end
end

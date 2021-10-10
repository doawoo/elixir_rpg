use ElixirRPG.DSL.System

defsystem ReaperSystem do
  require Logger

  name "ReaperSystem"

  wants DemoStats

  on_tick do
    _ = delta_time
    _ = frontend_pid

    dead? = get_component_data(DemoStats, :dead)
    hp_neg? = get_component_data(DemoStats, :hp) <= 0

    if dead? || hp_neg? do
      get_all_components()
      |> Map.keys()
      |> Enum.each(fn comp ->
        ElixirRPG.Entity.EntityStore.remove_entity_from_group(comp, world_name, entity)
      end)

      ElixirRPG.Entity.EntityStore.add_entity_to_group(:__dead__, world_name, entity)
      GenServer.call(entity, :destroy)
    end
  end
end

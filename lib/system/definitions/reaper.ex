use ElixirRPG.DSL.System

defsystem ReaperSystem do
  require Logger

  name "ReaperSystem"

  wants DemoStats

  on_tick do
    _ = delta_time
    _ = world_name
    _ = frontend_pid

    dead? = get_component_data(DemoStats, :dead)

    if dead? do
      ElixirRPG.World.remove_entity(world_name, entity)
    end
  end
end

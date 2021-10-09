use ElixirRPG.DSL.System

defsystem CastingSystem do
  require Logger

  alias ElixirRPG.RuntimeSystems.AnimateModSystem
  alias ElixirRPG.Action

  name "ClearSpecialStateSystem"

  wants DemoStats

  on_tick do
    _ = world_name
    _ = frontend_pid

    data = get_all_components()
    stats = data[DemoStats]

    if stats.casting do
      new_time = stats.casting_delay - delta_time

      if new_time <= 0 do
        Action.execute(stats.casting_data)

        set_component_data(DemoStats, :casting, false)
        set_component_data(DemoStats, :casting_data, nil)
        set_component_data(DemoStats, :casting_delay, 0.0)
      else
        set_component_data(DemoStats, :casting_delay, new_time)

        AnimateModSystem.add_animation(
          entity,
          "animate__shakeY animate__infinite",
          1.0
        )
      end
    end
  end
end

use ElixirRPG.DSL.System

defsystem ClearStateSystem do
  require Logger

  name "ClearSpecialStateSystem"

  wants DemoStats
  wants Sprite

  on_tick do
    _ = delta_time
    _ = world_name
    _ = frontend_pid

    data = get_all_components()

    if data[Sprite].override_delay > 0 do
      new_time = max(0, data[Sprite].override_delay - delta_time)
      set_component_data(Sprite, :override_delay, new_time)
    end

    set_component_data(DemoStats, :just_took_damage, false)
  end
end

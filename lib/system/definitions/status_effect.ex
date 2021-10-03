use ElixirRPG.DSL.System

defsystem StatusEffectSystem do
  name "StatusEffectSystem"

  wants Status
  wants ActiveBattle
  wants DemoStats

  on_tick do
    _ = world_name
    _ = frontend_pid

    new_status_list =
      get_component_data(Status, :status_list)
      |> Enum.map(fn {type, time_applied} ->
        {type, time_applied + delta_time}
      end)
      |> Enum.map(fn {type, time_applied} -> apply_status(entity, type, time_applied) end)

    set_component_data(Status, :status_list, new_status_list)
  end

  defp apply_status(entity, type, time_applied) do
    do_apply_status(entity, time_applied, type)
  end

  defp do_apply_status(entity, time_applied, type) do
    effect_data = apply(Module.concat(ElixirRPG, StatusEffects), type, [])

    if time_applied >= effect_data.interval do
      if effect_data.on_inflict != nil do
        effect_data.on_inflict.(entity)
      end

      {type, 0.0}
    else
      {type, time_applied}
    end
  end
end

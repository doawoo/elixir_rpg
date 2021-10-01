use ElixirRPG.DSL.System

defsystem StatusEffectSystem do
  @status_table %{
    poison: [interval: 5.0, damage: 3.0],
    burn: [interval: 1.0, damage: 1.0],
    brain_freeze: [pause_atb: true]
  }

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
    status_data = @status_table[type]
    do_apply_status(entity, time_applied, type, status_data)
  end

  defp do_apply_status(entity, time_applied, type, interval: interval, damage: dmg) do
    inflict_times = (time_applied / interval) |> trunc()
    inflict_dmg = dmg * inflict_times
    curr_hp = get_component_data(DemoStats, :hp)
    set_component_data(DemoStats, :hp, curr_hp - inflict_dmg)

    if inflict_dmg > 0 do
      {type, 0.0}
    else
      {type, time_applied}
    end
  end

  defp do_apply_status(entity, _, _, pause_atb: true) do
    set_component_data(ActiveBattle, :frozen, true)
  end
end

use ElixirRPG.DSL.System

defsystem StatusEffectSystem do
  name "StatusEffectSystem"

  wants Status
  wants ActiveBattle
  wants DemoStats

  alias ElixirRPG.Entity

  on_tick do
    _ = world_name
    _ = frontend_pid

    to_be_added = get_component_data(Status, :to_be_added)
    current_status_list = to_be_added ++ get_component_data(Status, :status_list)

    set_component_data(Status, :to_be_added, [])

    Enum.each(to_be_added, fn {type, _} ->
      effect_data = apply(Module.concat(ElixirRPG, StatusEffects), type, [])
      effect_data.on_applied.(entity)
    end)

    new_status_list =
      current_status_list
      |> Enum.map(fn {type, time_applied} ->
        {type, time_applied + delta_time}
      end)
      |> Enum.map(fn {type, time_applied} -> apply_status(entity, type, time_applied) end)
      |> Enum.filter(fn {type, _} -> type != :__expired__ end)

    set_component_data(Status, :status_list, new_status_list)
  end

  def add_status_to_entity(entity, effect_type) when is_pid(entity) and is_atom(effect_type) do
    comp_data = Entity.get_component(entity, Status)
    new_list = [{effect_type, 0.0} | comp_data.to_be_added]

    Entity.set_component_data(entity, Status, :to_be_added, new_list)
  end

  defp apply_status(entity, type, time_applied) do
    do_apply_status(entity, time_applied, type)
  end

  defp do_apply_status(entity, time_applied, type) do
    effect_data = apply(Module.concat(ElixirRPG, StatusEffects), type, [])

    if :math.fmod(time_applied, effect_data.interval) != 0 do
      if effect_data.on_inflict != nil do
        effect_data.on_inflict.(entity)
      end
    end

    if time_applied >= effect_data.max_duration do
      if effect_data.on_removed != nil do
        effect_data.on_removed.(entity)
      end

      {:__expired__, 0.0}
    else
      {type, time_applied}
    end
  end
end

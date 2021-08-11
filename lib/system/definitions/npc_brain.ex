use ElixirRPG.DSL.System

defsystem NPCBrainSystem do
  name "EnemyBrainSystem"

  wants ActorName
  wants ActorStats
  wants ActiveBattle
  wants NPCBrain

  on_tick do
    name = get_component_data(ActorName, :name)
    code = get_component_data(NPCBrain, :cached_src)
    brain_name = get_component_data(NPCBrain, :brain_name)
    can_act? = get_component_data(ActiveBattle, :ready)

    if can_act? do
      # Consume ATB gauge
      set_component_data(ActiveBattle, :ready, false)
      set_component_data(ActiveBattle, :atb_value, 0.0)

      # If we cached this code already don't load it again
      src =
        if code == "" do
          load_script_file(entity, "brains/#{brain_name}.brain.exs")
        else
          code
        end

      Code.eval_string(src, entity: entity, get_components: &script_binding_get_components/1)

      log("Entity NPC #{name} consumed ATB and is going to act!")
    end
  end

  defp script_binding_get_components(entity) do
    get_all_components()
  end

  defp load_script_file(entity, file) do
    code = File.read!(file)
    warn("Going to load code file: #{file} into component cache")
    set_component_data(NPCBrain, :cached_src, code)
    code
  end
end

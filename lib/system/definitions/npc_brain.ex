use ElixirRPG.DSL.System

alias ElixirRPG.Action
alias ElixirRPG.Entity.EntityStore

defsystem NPCBrainSystem do
  name "EnemyBrainSystem"

  wants ActorName
  wants ActorStats
  wants ActiveBattle
  wants NPCBrain

  @common_keyword "#! import_common"
  @common_code_path "brains/common.exs"
  @common_code File.read!(@common_code_path)

  def __mix_recompile__? do
    :erlang.md5(@common_code) != File.read!(@common_code_path) |> :erlang.md5()
  end

  on_tick do
    name = get_component_data(ActorName, :name)
    code = get_component_data(NPCBrain, :cached_src)
    brain_name = get_component_data(NPCBrain, :brain_name)
    can_act? = get_component_data(ActiveBattle, :ready)

    if can_act? do
      # Consume ATB gauge
      set_component_data(ActiveBattle, :ready, false)
      set_component_data(ActiveBattle, :atb_value, 0.0)

      # If we cached this brain already don't load it again
      src =
        if code == "" do
          load_script_file(entity, "brains/#{brain_name}.brain.exs")
        else
          code
        end

      Code.eval_string(src,
        entity: entity,
        world: world_name,
        get_components: &script_binding_get_components/1,
        make_action: &Action.make_action/3,
        execute_action: &Action.execute/1,
        get_entities_with: &EntityStore.get_entities_with/2
      )

      log("Entity NPC #{name} consumed ATB and is going to act!")
    end
  end

  defp load_script_file(entity, file) do
    code =
      File.read!(file)
      |> String.replace(@common_keyword, @common_code)

    IO.inspect(code)

    warn("Going to load code file: #{file} into component cache")
    set_component_data(NPCBrain, :cached_src, code)
    code
  end

  ### Script Binding Functions

  defp script_binding_get_components(entity) do
    get_all_components()
  end
end

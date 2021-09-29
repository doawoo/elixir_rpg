use ElixirRPG.DSL.System

defsystem AnimateModSystem do
  require Logger

  alias ElixirRPG.Entity

  name "AnimateModSystem"

  wants AnimationMod

  on_tick do
    _ = delta_time
    _ = frontend_pid
    _ = world_name
    current_anims = get_component_data(AnimationMod, :active_mods)

    updated_values =
      Enum.map(current_anims, fn {anim, tick_count} ->
        {anim, tick_count - 1}
      end)
      |> Enum.filter(fn {_, tick_count} -> tick_count > 0 end)

    set_component_data(AnimationMod, :active_mods, updated_values)
  end

  def add_animation(entity, animation_class, len \\ 5) do
    anim_data = Entity.get_component(entity, AnimationMod)
    new_anim = {animation_class, len}
    new_data = [new_anim | anim_data.active_mods]
    Entity.set_component_data(entity, AnimationMod, :active_mods, new_data)
  end
end

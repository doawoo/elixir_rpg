use ElixirRPG.DSL.System

defsystem SpecialSpriteSystem do
  require Logger

  @sprite_override_hit "hit.png"
  @sprite_override_ready "ready.png"
  @sprite_override_low_hp "hit.png"
  @sprite_override_low_hp_ready "low.png"
  @sprite_override_casting "cast.png"

  name "SpecialSprites"

  wants ActorName
  wants ActiveBattle
  wants DemoStats
  wants Sprite

  def set_sprite_override(entity, image_name, len \\ 0)
      when is_binary(image_name) and is_number(len) do
    set_component_data(Sprite, :sprite_override, image_name)
    set_component_data(Sprite, :override_delay, len)
  end

  on_tick do
    _ = delta_time
    _ = world_name
    _ = frontend_pid

    data = get_all_components()

    # Conditions we care about
    ready = data[ActiveBattle].ready
    low_health = data[DemoStats].hp <= data[DemoStats].max_hp / 2
    casting = data[DemoStats].casting

    # Only override if we have an override directory AND aren't displaying an override for a delay period
    if data[Sprite].base_sprite_dir != "" && data[Sprite].override_delay <= 0 do
      cond do
        casting -> set_sprite_override(entity, @sprite_override_casting, 0.5)
        ready && low_health -> set_sprite_override(entity, @sprite_override_low_hp_ready)
        low_health -> set_sprite_override(entity, @sprite_override_low_hp)
        ready -> set_sprite_override(entity, @sprite_override_ready)
        true -> set_sprite_override(entity, "")
      end
    end
  end
end

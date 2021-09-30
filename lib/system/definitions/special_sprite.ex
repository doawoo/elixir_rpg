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

  on_tick do
    _ = delta_time
    _ = world_name
    _ = frontend_pid

    data = get_all_components()

    # Conditions we care about
    ready = data[ActiveBattle].ready
    low_health = data[DemoStats].hp <= data[DemoStats].max_hp / 2
    took_damage = data[DemoStats].just_took_damage == true
    casting = data[DemoStats].casting

    # Only override if we have an override directory AND aren't displaying an override for a delay period
    if data[Sprite].base_sprite_dir != "" && data[Sprite].override_delay <= 0 do
      cond do
        took_damage ->
          set_component_data(Sprite, :sprite_override, @sprite_override_hit)
          set_component_data(Sprite, :override_delay, 2.0)

        casting ->
          set_component_data(Sprite, :sprite_override, @sprite_override_casting)

        ready && low_health ->
          set_component_data(Sprite, :sprite_override, @sprite_override_low_hp_ready)

        low_health ->
          set_component_data(Sprite, :sprite_override, @sprite_override_low_hp)

        ready ->
          set_component_data(Sprite, :sprite_override, @sprite_override_ready)

        true ->
          set_component_data(Sprite, :sprite_override, "")
      end
    end
  end
end

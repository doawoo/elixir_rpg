use ElixirRPG.DSL.Component

defcomponent Sprite do
  member :sprite_name, "UNDEFINED_SPRITE"
  member :base_sprite_dir, ""
  member :sprite_override, ""
  member :override_delay, 0.0
  member :full_image, false
end

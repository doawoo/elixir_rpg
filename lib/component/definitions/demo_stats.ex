use ElixirRPG.DSL.Component

defcomponent DemoStats do
  member :max_hp, 100
  member :hp, 100

  member :max_mp, 100
  member :mp, 15

  member :speed, 15

  member :defense, 5

  member :attack_power, 5

  member :just_took_damage, false

  member :casting, false
  member :casting_data, nil
  member :casting_delay, 0.0

  member :dead, false
end

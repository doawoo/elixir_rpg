#! import_common

####
# Frown balloon enemy brain script
# Picks a random play character and applies a debuff to them
####

if enemies != [] && player_characters != [] do
  required_mp = 20
  current_mp = Entity.get_component(entity, DemoStats).mp

  if Entity.get_component(entity, DemoStats).mp >= required_mp do
    casting_delay = 3.5
    target = Enum.random(player_characters)
    effect = Enum.random([:burn, :shock])

    if target do
      bad_action = ActionTypes.give_status(target, effect)
      Entity.set_component_data(entity, DemoStats, :casting, true)
      Entity.set_component_data(entity, DemoStats, :casting_data, bad_action)
      Entity.set_component_data(entity, DemoStats, :casting_delay, casting_delay)
      Entity.set_component_data(entity, DemoStats, :mp, current_mp - required_mp)
    end
  end
end
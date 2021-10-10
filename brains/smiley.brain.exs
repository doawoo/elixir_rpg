#! import_common

####
# Smile balloon enemy brain script
# Heals a random npc who does not have full health
####

if enemies != [] do
  required_mp = 10
  current_mp = Entity.get_component(entity, DemoStats).mp

  if Entity.get_component(entity, DemoStats).mp >= required_mp do
    casting_delay = 2.0
    heal_target = Enum.find(enemies, fn ent ->
      current_hp = Entity.get_component(ent, DemoStats).hp
      max_hp = Entity.get_component(ent, DemoStats).max_hp
      current_hp < max_hp
    end) 

    if heal_target do
      heal_action = ActionTypes.heal(heal_target, 15)

      Entity.set_component_data(entity, ActiveBattle, :atb_value, 0.0)
      Entity.set_component_data(entity, DemoStats, :casting, true)
      Entity.set_component_data(entity, DemoStats, :casting_data, heal_action)
      Entity.set_component_data(entity, DemoStats, :casting_delay, casting_delay)

      Entity.set_component_data(entity, DemoStats, :mp, current_mp - required_mp)
    end
  end
end
#! import_common

####
# Smile balloon enemy brain script
# Heals a random npc 
####

if enemies != [] do
  heal_target = Enum.random(enemies)
  heal_action = ActionTypes.heal(heal_target, 15)

  # Execute attack action
  Action.execute(heal_action)
end
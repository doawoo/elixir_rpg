#! import_common

####
# Walker enemy brain script
####

# Select a totally random player character in the party
if player_characters != [] do
  random_pc = Enum.random(player_characters)

  # Attack them with non-pierce physical damange
  dmg = 2
  atk_action = ActionTypes.physical_damage(random_pc, dmg, false)

  # Execute attack action
  Action.execute(atk_action)
end
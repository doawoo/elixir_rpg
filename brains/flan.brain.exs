#! import_common

####
# Flan enemy brain script
####

# Select a totally random player character in the party
if player_characters != [] do
  random_pc = Enum.random(player_characters)

  # Attack them with non pierce physical damange
  atk_action = ActionTypes.physical_damage(random_pc, self[ActorStats].strength, false)

  # Execute attack action
  Action.execute(atk_action)
end
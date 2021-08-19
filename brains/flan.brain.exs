#! import_common

####
# Flan enemy brain script
####

# Select a totally random player character in the party
random_pc = Enum.random(player_characters)

# Build an attack intent action that targets them
atk_action = make_action.(:attack, random_pc, %{
  attack_type: :physical,
  strength: self[ActorStats].strength,
})

# Execute attack action
execute_action.(atk_action)
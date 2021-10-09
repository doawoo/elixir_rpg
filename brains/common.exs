## COMMON SCRIPT CODE

self = get_components.(entity)
player_characters = EntityStore.get_entities_with([ActionList], world)
enemies = EntityStore.get_entities_with([Enemy], world)

## END COMMON CODE

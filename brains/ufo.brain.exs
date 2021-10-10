#! import_common

####
# UFO Brain
# The most complex brain of them all.
#
# When there are no allies on the feild:
#    Spawn a set (2)
#
# When there are allies on the field:
#    If they are all ok (above 1/2 health):
#        Attack the PC with the most HP
#    If they are all not ok (below 1/2 health):
#        Cast SHOCK on all PC
####

enemy_sets = [
  {Frowny, Smiley},
  {Walker, Walker},
  {Cone, Cone},
  {Cone, Cylinder},
  {Cylinder, Cylinder},
  {Cone, Walker}
]

if length(enemies) > 1 do
  IO.inspect("ATTACK RANDOM PC")
  enemies_are_ok? = Enum.all?(enemies, fn ent ->
    current_hp = Entity.get_component(ent, DemoStats).hp
    max_hp = Entity.get_component(ent, DemoStats).max_hp
    current_hp < (max_hp / 2)
  end)

  if enemies_are_ok? do
    # find PC with most health
    target = Enum.sort_by(player_characters, fn ent ->
      Entity.get_component(ent, DemoStats).hp
    end) |> List.first()

    # attack them
    dmg = 10
    atk_action = ActionTypes.physical_damage(target, dmg, false)
    Action.execute(atk_action)
  else
    # Cast shock on all players
    Enum.each(player_characters, fn ent ->
      shock_action = ActionTypes.give_status(ent, :shock)
      current_mp = Entity.get_component(entity, DemoStats).mp
      casting_delay = 2.5

      IO.inspect("SHOCK PC")

      Entity.set_component_data(entity, DemoStats, :casting, true)
      Entity.set_component_data(entity, DemoStats, :casting_data, shock_action)
      Entity.set_component_data(entity, DemoStats, :casting_delay, casting_delay)
    end)
  end
else
  # Spawn some friends!
  IO.inspect("SPAWN FRIENDS")
  casting_delay = 1.5
  spawn_set = Enum.random(enemy_sets)
  spawn_action = ActionTypes.spawn(entity, spawn_set)
  Entity.set_component_data(entity, DemoStats, :casting, true)
  Entity.set_component_data(entity, DemoStats, :casting_data, spawn_action)
  Entity.set_component_data(entity, DemoStats, :casting_delay, casting_delay)
end
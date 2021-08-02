use ElixirRPG.DSL.System

defsystem TestPoisonSystem do
  alias ElixirRPG.Component.ActorStats

  name("Poison Effect")

  wants(ActorStats)
  wants(Poison)

  on_tick do
    # Fetch the current state of the component data
    dmg_amount = get_component_data(ActorStats, :dmg_per_tick)
    duration = get_component_data(Poison, :duration)
    current_hp = get_component_data(ActorStats, :hp)

    # Now modify them
    set_component_data(ActorStats, :hp, current_hp - dmg_amount)
    set_component_data(Poison, :duration, duration - 1)
  end
end

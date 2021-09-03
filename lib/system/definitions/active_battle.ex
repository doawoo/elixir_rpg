use ElixirRPG.DSL.System

defsystem ActiveBattleSystem do
  # Simple system that bumps the ATB value on any entity that has one
  # Caps at and sets :ready to true when equal to 1.0

  require Logger

  name "ATBSystem"

  wants ActorName
  wants ActorStats
  wants ActiveBattle

  on_tick do
    _world = world_name

    name = get_component_data(ActorName, :name)
    speed_stat = get_component_data(ActorStats, :speed)
    current_atb = get_component_data(ActiveBattle, :atb_value)

    if current_atb < 1.0 do
      new_atb_value = current_atb + speed_stat / 1000

      if new_atb_value >= 1.0 do
        set_component_data(ActiveBattle, :atb_value, 1.0)
        set_component_data(ActiveBattle, :ready, true)
      else
        set_component_data(ActiveBattle, :atb_value, new_atb_value)
      end
    end
  end
end

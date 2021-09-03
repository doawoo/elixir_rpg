use ElixirRPG.DSL.System

defsystem DrawingSystem do
  require Logger

  name "CombatSystem"

  wants ActorName
  wants ActorStats
  wants ActiveBattle
  wants Sprite

  on_tick do
    _world = world_name
    data = get_all_components()

    send(frontend_pid, {:_push_drawable, entity, data})
  end
end

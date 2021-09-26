use ElixirRPG.DSL.System

defsystem DrawingSystem do
  require Logger

  name "DrawingSystem"

  wants ActorName
  wants Sprite

  on_tick do
    _world = world_name
    data = get_all_components()

    send(frontend_pid, {:_push_drawable, entity, data})
  end
end

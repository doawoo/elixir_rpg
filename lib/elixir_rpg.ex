defmodule ElixirRPG do
  alias ElixirRPG.World
  alias ElixirRPG.RuntimeSystems

  require Logger

  def start do
    # First we create a world
    {:ok, the_world} = World.start_link(:testing_world)

    # Pause it for now
    World.pause(the_world)

    # Now add systems
    systems = [
      RuntimeSystems.ActiveBattleSystem
    ]

    Enum.each(systems, fn s -> World.add_system(the_world, s) end)

    # Add some entities to the world
    # Three flans
    World.add_entity(the_world, Flan)

    # Un-pause the world and play!
    World.resume(the_world)
  end
end

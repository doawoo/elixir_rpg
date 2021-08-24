defmodule ElixirRPG do
  alias ElixirRPG.World
  alias ElixirRPG.RuntimeSystems

  require Logger

  def start do
    # First create a world
    {:ok, the_world} = World.start_link(:testing_world)

    # Pause it for now
    World.pause(the_world)

    # Now add systems
    systems = [
      RuntimeSystems.ActiveBattleSystem,
      RuntimeSystems.NPCBrainSystem,
      RuntimeSystems.CombatSystem
    ]

    Enum.each(systems, fn s -> World.add_system(the_world, s) end)

    # Add some entities to the world
    World.add_entity(the_world, Flan)

    # Add the player character
    World.add_entity(the_world, Zidane)

    # Un-pause the world and play!
    World.resume(the_world)
  end
end

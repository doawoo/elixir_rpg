defmodule ElixirRPG do
  alias ElixirRPG.World
  alias ElixirRPG.World.Input
  alias ElixirRPG.RuntimeSystems

  require Logger

  def start(world_name, front_end_pid) do
    name = String.to_atom(world_name)

    # First create a world
    {:ok, the_world} = World.start_link(name, front_end_pid)
    {:ok, input_server} = World.InputServer.start_link(name)

    Logger.info("Booted World at PID: #{inspect(the_world)}")
    Logger.info("Booted InputServer at PID: #{inspect(input_server)}")

    # Pause it for now
    World.pause(the_world)

    # Now add systems
    systems = [
      RuntimeSystems.ActiveBattleSystem,
      RuntimeSystems.PlayerInput,
      RuntimeSystems.NPCBrainSystem,
      RuntimeSystems.CombatSystem,
      RuntimeSystems.DrawingSystem
    ]

    Enum.each(systems, fn s -> World.add_system(the_world, s) end)

    the_world
  end

  def get_pending_input(world) do
    World.InputServer.peek_input(world)
  end

  def input_attack(world, player, target) do
    input = %Input{
      input_type: :liveview_input,
      from_entity: player,
      input_paramters: {:phys_attack, target}
    }

    GenServer.call(world, {:input, input})
  end

  def add_player(world) do
    World.add_entity(world, Zidane)
  end

  def add_flan(world) do
    World.add_entity(world, Flan)
  end
end

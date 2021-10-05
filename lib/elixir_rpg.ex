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
    systems =
      [
        RuntimeSystems.StatusEffectSystem,
        RuntimeSystems.ActiveBattleSystem,
        RuntimeSystems.PlayerInput,
        RuntimeSystems.NPCBrainSystem,
        RuntimeSystems.CombatSystem,
        RuntimeSystems.SpecialSpriteSystem,
        RuntimeSystems.DrawingSystem,
        RuntimeSystems.AnimateModSystem,
        RuntimeSystems.ClearStateSystem,
        RuntimeSystems.ReaperSystem
      ]
      |> Enum.reverse()

    Enum.each(systems, fn s -> World.add_system(the_world, s) end)

    the_world
  end

  def get_pending_input(world) do
    World.InputServer.peek_input(world)
  end

  def clear_input(world, from) do
    World.InputServer.clear_input(world, from)
  end

  def do_input(world, from, type, parameters) do
    input = %Input{
      input_type: type,
      from_entity: from,
      input_paramters: parameters
    }

    World.InputServer.push_input(world, input)
  end
end

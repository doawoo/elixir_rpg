defmodule ElixirRPG do
  alias ElixirRPG.World

  require Logger

  def test_harness do
    {:ok, world_pid} = World.start_link("test_world", :the_world)
    Logger.info("Started World at PID: #{inspect(world_pid)}")
  end
end

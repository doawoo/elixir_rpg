defmodule ElixirRPG.World.InputServer do
  alias ElixirRPG.World.Input
  use GenServer

  require Logger

  # Client Frontend Functions

  def start_link(world) when is_atom(world) do
    GenServer.start_link(__MODULE__, [], name: full_name(world))
  end

  def peek_input(world) do
    GenServer.call(full_name(world), :peek_input)
  end

  def push_input(world, %Input{} = input) do
    GenServer.cast(full_name(world), {:push, input})
  end

  def clear_input(world, %Input{} = input) do
    GenServer.cast(full_name(world), {:push, input})
  end

  defp full_name(world_name), do: Module.concat(world_name, :input_server)

  # Input Callbacks

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call(:peek_input, _from, state) do
    {:reply, state, state}
  end

  def handle_call(msg, _from, state) do
    Logger.warn("Unknown call message: #{msg}")
    {:reply, state, state}
  end

  @impl GenServer
  def handle_cast({:push_input, source_pid, %Input{} = input}, state) do
    {:noreply, Map.put(state, source_pid, input)}
  end

  def handle_cast({:clear_input, source_pid}, state) do
    {:reply, Map.delete(state, source_pid)}
  end

  def handle_cast(msg, state) do
    Logger.warn("Unknown cast message: #{msg}")
    {:noreply, state}
  end
end

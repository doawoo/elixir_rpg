defmodule ElixirRPG.World do
  use GenServer

  alias ElixirRPG.World
  alias ElixirRPG.Entity

  @initial_state %World.Data{target_tick_rate: 15}

  def start_link(name, proc_name) when is_binary(name) and is_atom(proc_name) do
    GenServer.start_link(__MODULE__, [name: name], name: proc_name)
  end

  @impl GenServer
  def init(name: world_name) do
    state = @initial_state

    clock_ref = World.Clock.start_tick(state.target_tick_rate, self())
    {:ok, %World.Data{state | name: world_name, clock: clock_ref}}
  end

  @impl GenServer
  def handle_cast(:pause, current_state) do
    :timer.cancel(current_state.clock)
    {:noreply, %{current_state | clock: nil}}
  end

  def handle_cast(:resume, current_state) do
    :timer.cancel(current_state.clock)
    clock_ref = World.Clock.start_tick(current_state.target_tick_rate, self())
    {:ok, %{@initial_state | clock: clock_ref}}
  end

  def handle_cast({:broadcast, msg}, current_state) do
    Enum.each(current_state.children, fn pid -> GenServer.cast(pid, msg) end)
    {:noreply, current_state}
  end

  def handle_cast({:add_system, system}, current_state) do
    {:noreply, %World.Data{current_state | systems: [system | current_state.systems]}}
  end

  @impl GenServer
  def handle_info(:tick, current_state) do
    {:noreply, current_state}
  end

  @impl GenServer
  def handle_call({:add_child, child, args}, _from, current_state) do
    {:ok, new_child_pid} = GenServer.start_link(child, args)
    new_state = %{current_state | children: [new_child_pid | current_state.children]}
    {:reply, new_child_pid, new_state}
  end
end

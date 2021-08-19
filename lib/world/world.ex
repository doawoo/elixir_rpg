defmodule ElixirRPG.World do
  use GenServer

  alias ElixirRPG.World
  alias ElixirRPG.Entity
  alias ElixirRPG.Entity.EntityStore

  @initial_state %World.Data{target_tick_rate: 15}

  def start_link(name) when is_atom(name) do
    GenServer.start_link(__MODULE__, [name: name], name: name)
  end

  def add_system(world, system) when is_pid(world) and is_atom(system) do
    GenServer.cast(world, {:add_system, system})
  end

  def add_entity(world, type) when is_pid(world) and is_atom(type) do
    GenServer.cast(world, {:add_entity, type})
  end

  def pause(world) when is_pid(world) do
    GenServer.cast(world, :pause)
  end

  def resume(world) when is_pid(world) do
    GenServer.cast(world, :resume)
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
    clock_ref = World.Clock.start_tick(current_state.target_tick_rate, self())
    {:noreply, %{current_state | clock: clock_ref}}
  end

  def handle_cast({:add_system, system}, current_state) do
    {:noreply, %World.Data{current_state | systems: [system | current_state.systems]}}
  end

  def handle_cast({:add_entity, entity_type}, current_state) do
    Entity.create_entity(entity_type, current_state.name)
    {:noreply, current_state}
  end

  @impl GenServer
  def handle_info(:tick, current_state) do
    Enum.each(current_state.systems, fn system ->
      ents =
        system.wants()
        |> EntityStore.get_entities_with(current_state.name)

      system.__tick(ents, current_state.name)
    end)

    {:noreply, current_state}
  end
end

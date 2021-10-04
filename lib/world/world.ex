defmodule ElixirRPG.World do
  use GenServer

  alias ElixirRPG.World
  alias ElixirRPG.Entity
  alias ElixirRPG.Entity.EntityStore

  require Logger

  @initial_state %World.Data{target_tick_rate: 15, last_tick: nil}

  def start_link(name, live_view_frontend \\ nil) when is_atom(name) do
    GenServer.start_link(__MODULE__, [args: {name, live_view_frontend}], name: name)
  end

  def add_system(world, system) when is_pid(world) and is_atom(system) do
    GenServer.cast(world, {:add_system, system})
  end

  def add_entity(world, type) when is_pid(world) and is_atom(type) do
    GenServer.cast(world, {:add_entity, type})
  end

  def remove_entity(world, entity) when is_pid(world) and is_pid(entity) do
    GenServer.cast(world, {:remove_entity, entity})
  end

  def pause(world) when is_pid(world) do
    GenServer.cast(world, :pause)
  end

  def resume(world) when is_pid(world) do
    GenServer.cast(world, :resume)
  end

  @impl GenServer
  def init(args: args) do
    state = @initial_state

    {world_name, liveview_pid} = args

    clock_ref = World.Clock.start_tick(state.target_tick_rate, self())

    curr_time = :os.system_time(:millisecond)

    {:ok,
     %World.Data{
       state
       | name: world_name,
         frontend: liveview_pid,
         clock: clock_ref,
         last_tick: curr_time
     }}
  end

  @impl GenServer
  def handle_cast(:pause, current_state) do
    Logger.info("PAUSE WORLD: #{current_state.name}")
    {:noreply, %{current_state | playing: false}}
  end

  def handle_cast(:resume, current_state) do
    Logger.info("RESUME WORLD: #{current_state.name}")
    {:noreply, %{current_state | playing: true}}
  end

  def handle_cast({:add_system, system}, current_state) do
    {:noreply, %World.Data{current_state | systems: [system | current_state.systems]}}
  end

  def handle_cast({:remove_entity, entity}, current_state) do
    Process.exit(entity, 0)
    {:noreply, current_state}
  end

  def handle_cast({:add_entity, entity_type}, current_state) do
    Entity.create_entity(entity_type, current_state.name)
    {:noreply, current_state}
  end

  @impl GenServer
  def handle_call(message, from, current_state) do
    Logger.warn("Unkown message type #{inspect(message)}, from #{inspect(from)}")
    {:reply, :ok, current_state}
  end

  @impl GenServer
  def handle_info(:tick, current_state) do
    curr_time = :os.system_time(:millisecond)
    last_tick_time = current_state.last_tick
    delta_time = (curr_time - last_tick_time) / 1000

    if current_state.playing do
      Enum.each(current_state.systems, fn system ->
        ents =
          system.wants()
          |> EntityStore.get_entities_with(current_state.name)

        system.__tick(ents, current_state.name, current_state.frontend, delta_time)
      end)
    end

    update_frontend_world_state(current_state)
    flush_frontend_backbuffer(current_state)

    {:noreply, %World.Data{current_state | last_tick: curr_time}}
  end

  def update_frontend_world_state(state) do
    send(
      state.frontend,
      {:_force_update,
       fn socket ->
         Phoenix.LiveView.assign(socket, :world_data, state)
       end}
    )
  end

  def flush_frontend_backbuffer(state) do
    send(state.frontend, :_flush_backbuffer)
  end
end

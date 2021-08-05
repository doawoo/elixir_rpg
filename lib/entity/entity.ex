defmodule ElixirRPG.Entity do
  use GenServer

  require Logger

  alias ElixirRPG.Entity

  def create_entity(type) when is_atom(type) do
    full_type = Module.concat(ElixirRPG.EntityTypes, type)
    data = full_type.create()
    start_link(data)
  end

  def start_link(%Entity.Data{} = entity_data) do
    GenServer.start_link(__MODULE__, data: entity_data)
  end

  @impl GenServer
  def init(data: entity_data) do
    {:ok, entity_data}
  end

  @impl GenServer
  def handle_call({:add_component, type, data}, _from, entity_data)
      when is_atom(type) and is_map(data) do
    full_type = Module.concat(ElixirRPG.ComponentTypes, type)

    if Map.has_key?(entity_data.components, full_type) do
      {:reply, :error, entity_data}
    else
      new_component = struct(full_type, data)

      {:reply, :ok,
       %Entity.Data{
         entity_data
         | components: Map.put_new(entity_data.components, type, new_component)
       }}
    end
  end

  def handle_call({:remove_component, type}, _from, entity_data) when is_atom(type) do
    {:reply, :ok,
     %Entity.Data{entity_data | components: Map.delete(entity_data.components, type)}}
  end

  def handle_call({:get_component, type}, _from, entity_data) when is_atom(type) do
    {:reply, Map.get(entity_data.components, type), entity_data}
  end

  def handle_call(:get_all_components, _from, entity_data) do
    {:reply, entity_data.components, entity_data}
  end

  def handle_call({:set_world, world_ref}, _from, entity_data) when is_pid(world_ref) do
    {:reply, :ok, %Entity.Data{entity_data | world_ref: world_ref}}
  end

  def handle_call(unknown_message, from, entity_data) do
    Logger.warn(
      "#{inspect(self())} got an unknown message from #{inspect(from)}: #{
        inspect(unknown_message)
      }"
    )

    {:reply, :ok, entity_data}
  end
end

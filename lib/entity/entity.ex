defmodule ElixirRPG.Entity do
  use GenServer

  require Logger

  alias ElixirRPG.Entity
  alias ElixirRPG.Entity.EntityStore

  def create_entity(type, world_name) when is_atom(type) do
    full_type = Module.concat(ElixirRPG.EntityTypes, type)
    data = full_type.create()
    data = %Entity.Data{data | world_name: world_name}
    start_link(data)
  end

  def start_link(%Entity.Data{} = entity_data) do
    GenServer.start_link(__MODULE__, data: entity_data)
  end

  @impl GenServer
  def init(data: entity_data) do
    Enum.each(entity_data.components, fn {k, _} ->
      register_with_component_group(k, entity_data.world_name)
    end)

    {:ok, entity_data}
  end

  @impl GenServer
  def handle_call({:add_component, type, data}, _from, entity_data)
      when is_atom(type) and is_map(data) do
    full_type = Module.concat(ElixirRPG.ComponentTypes, type)

    if Map.has_key?(entity_data.components, type) do
      {:reply, :error, entity_data}
    else
      new_component = struct(full_type, data)

      register_with_component_group(type, entity_data.world_name)

      {:reply, :ok,
       %Entity.Data{
         entity_data
         | components: Map.put_new(entity_data.components, type, new_component)
       }}
    end
  end

  def handle_call({:remove_component, type}, _from, entity_data) when is_atom(type) do
    unregister_with_component_group(type, entity_data.world_name)

    {:reply, :ok,
     %Entity.Data{entity_data | components: Map.delete(entity_data.components, type)}}
  end

  def handle_call({:get_component, type}, _from, entity_data) when is_atom(type) do
    {:reply, Map.get(entity_data.components, type), entity_data}
  end

  def handle_call(:get_all_components, _from, entity_data) do
    {:reply, entity_data.components, entity_data}
  end

  def handle_call({:set_world_name, world_name}, _from, entity_data) when is_pid(world_name) do
    {:reply, :ok, %Entity.Data{entity_data | world_name: world_name}}
  end

  def handle_call({:set_component_data, type, key, value}, _from, entity_data) do
    case Map.get(entity_data.components, type) do
      %{} = component ->
        updated_component = %{component | key => value}

        {:reply, :ok,
         %Entity.Data{
           entity_data
           | components: %{entity_data.components | type => updated_component}
         }}

      _ ->
        {:reply, :error, entity_data}
    end
  end

  def handle_call(unknown_message, from, entity_data) do
    Logger.warn(
      "#{inspect(self())} got an unknown message from #{inspect(from)}: #{
        inspect(unknown_message)
      }"
    )

    {:reply, :ok, entity_data}
  end

  defp register_with_component_group(type, world_name) do
    EntityStore.add_entity_to_group(type, world_name, self())
  end

  defp unregister_with_component_group(type, world_name) do
    EntityStore.remove_entity_from_group(type, world_name, self())
  end
end

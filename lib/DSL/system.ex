defmodule ElixirRPG.DSL.System do
  defmacro __using__(_options) do
    quote do
      import ElixirRPG.DSL.System
    end
  end

  defmacro defsystem(name, do: block) do
    quote do
      defmodule ElixirRPG.RuntimeSystems.unquote(name) do
        alias ElixirRPG.Entity

        require Logger

        Module.register_attribute(__MODULE__, :wants, accumulate: true, persist: true)
        Module.register_attribute(__MODULE__, :system_name, persist: true)

        defp __get_component_data(entity_pid, component_type, key) do
          case GenServer.call(entity_pid, {:get_component, component_type}) do
            %{} = component ->
              get_in(component, [Access.key!(key)])

            _ ->
              Logger.warn(
                "Could not fetch component #{inspect(component_type)} on #{inspect(entity_pid)}"
              )
          end
        end

        defp __set_component_data(entity_pid, component_type, key, new_value) do
          GenServer.call(entity_pid, {:set_component_data, component_type, key, new_value})
        end

        defp __add_component(entity_pid, component_type, default_data) do
          GenServer.call(entity_pid, {:add_component, component_type, default_data})
        end

        defp __remove_component(entity_pid, component_type) do
          GenServer.call(entity_pid, {:remove_component, component_type})
        end

        unquote(block)

        def wants do
          @wants
        end

        def name do
          @system_name
        end
      end
    end
  end

  defmacro get_component_data(component_type, key) do
    quote do
      __get_component_data(var!(entity), unquote(component_type), unquote(key))
    end
  end

  defmacro set_component_data(component_type, key, new_data) do
    quote do
      __set_component_data(var!(entity), unquote(component_type), unquote(key), unquote(new_data))
    end
  end

  defmacro add_component(component_type) do
    quote do
      __add_component(var!(entity), unquote(component_type))
    end
  end

  defmacro remove_component(component_type) do
    quote do
      __remove_component(var!(entity), unquote(component_type))
    end
  end

  defmacro name(name) do
    quote do
      @system_name unquote(name)
    end
  end

  defmacro wants(component_name) do
    quote do
      @wants unquote(component_name)
    end
  end

  defmacro on_tick(do: block) do
    quote do
      alias ElixirRPG.Util.PerfUtil

      def __process_entity(var!(entity)) do
        unquote(block)
      end

      def __tick(entity_list) when is_list(entity_list) do
        PerfUtil.parallel_map(entity_list, &__process_entity/1)
      end
    end
  end
end

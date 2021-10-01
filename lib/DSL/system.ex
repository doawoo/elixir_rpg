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

              nil
          end
        end

        defp __get_all_components(entity_pid) do
          GenServer.call(entity_pid, :get_all_components)
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

  defmacro log(item) do
    quote do
      ElixirRPG.Util.SystemLog.debug(unquote(item))
    end
  end

  defmacro warn(item) do
    quote do
      ElixirRPG.Util.SystemLog.warn(unquote(item))
    end
  end

  defmacro get_component_data(component_type, key) do
    quote do
      __get_component_data(var!(entity), unquote(component_type), unquote(key))
    end
  end

  defmacro get_all_components() do
    quote do
      __get_all_components(var!(entity))
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
    {:__aliases__, _, [type]} = component_name
    full_type = Module.concat(ElixirRPG.ComponentTypes, type)

    if !Code.ensure_compiled?(full_type) do
      raise(CompileError,
        description: "Component #{type} does not exist!",
        file: __CALLER__.file,
        line: __CALLER__.line
      )
    end

    quote do
      @wants unquote(component_name)
    end
  end

  defmacro on_tick(do: block) do
    quote do
      alias ElixirRPG.Util.PerfUtil

      def __process_entity(var!(entity), var!(world_name), var!(frontend_pid), var!(delta_time)) do
        unquote(block)
      end

      def __tick(entity_list, world_name, frontend_pid, delta_time)
          when is_list(entity_list) and is_atom(world_name) do
        PerfUtil.parallel_map(entity_list, fn ent ->
          __process_entity(ent, world_name, frontend_pid, delta_time)
        end)
      end
    end
  end
end

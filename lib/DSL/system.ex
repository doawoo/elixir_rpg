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

        Module.register_attribute(__MODULE__, :wants, accumulate: true, persist: true)
        Module.register_attribute(__MODULE__, :system_name, persist: true)

        defp __get_component_data(entity_pid, component_type, key) do
          case GenServer.call(entity_pid, {:get_component, component_type}) do
            {:ok, component} ->
              get_in(component, key)

            _ ->
              nil
          end
        end

        defp __set_component_data(entity_pid, component_type, key, new_value) do
          GenServer.call(entity_pid, {:set_component_member, component_type, key, new_value})
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
      def __tick(var!(entity_list)) when is_list(var!(entity_list)) do
        Enum.each(var!(entity_list), fn var!(entity) ->
          _ = var!(entity)
          unquote(block)
        end)
      end
    end
  end
end

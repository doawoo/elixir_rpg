defmodule ElixirRPG.DSL.Entity do
  defmacro __using__(_options) do
    quote do
      import ElixirRPG.DSL.Entity
    end
  end

  defmacro defentity(name, do: block) do
    quote do
      defmodule ElixirRPG.EntityTypes.unquote(name) do
        alias ElixirRPG.Entity

        Module.register_attribute(__MODULE__, :components, accumulate: true, persist: true)
        Module.register_attribute(__MODULE__, :entity_name, persist: true)

        unquote(block)

        defp __build_component(type, default_data) do
          full_type = Module.concat(ElixirRPG.ComponentTypes, type)
          struct(full_type, default_data)
        end

        def create do
          components =
            Enum.reduce(@components, %{}, fn {type, default_data}, acc ->
              comp = __build_component(type, default_data)
              Map.put_new(acc, type, comp)
            end)

          %Entity.Data{
            name: @entity_name,
            components: components
          }
        end
      end
    end
  end

  defmacro name(name) do
    quote do
      @entity_name unquote(name)
    end
  end

  defmacro component(component_type, default_data \\ %{}) do
    quote do
      @components {unquote(component_type), unquote(default_data)}
    end
  end
end

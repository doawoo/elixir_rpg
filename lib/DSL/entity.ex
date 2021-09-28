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
            components: components
          }
        end
      end
    end
  end

  defmacro component(component_type) do
    quote do
      @components {unquote(component_type), %{}}
    end
  end

  defmacro component(component_type, default_data) do
    {:__aliases__, _, [type]} = component_type
    full_type = Module.concat(ElixirRPG.ComponentTypes, type)

    if !Code.ensure_compiled?(full_type) do
      raise(CompileError,
        description: "Component #{type} does not exist!",
        file: __CALLER__.file,
        line: __CALLER__.line
      )
    end

    quote do
      @components {unquote(component_type), unquote(default_data)}
    end
  end
end

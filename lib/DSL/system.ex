defmodule ElixirRPG.DSL.System do
  defmacro __using__(_options) do
    quote do
      import ElixirRPG.DSL.System
    end
  end

  defmacro defsystem(name, do: block) do
    quote do
      defmodule ElixirRPG.RuntimeSystems.unquote(name) do
        Module.register_attribute(__MODULE__, :wants, accumulate: true, persist: true)
        Module.register_attribute(__MODULE__, :system_name, persist: true)

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
      def __tick() do
        unquote(block)
        :tock
      end
    end
  end
end
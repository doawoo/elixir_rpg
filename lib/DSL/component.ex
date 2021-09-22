defmodule ElixirRPG.DSL.Component do
  defmacro __using__(_options) do
    quote do
      use TypedStruct
      import ElixirRPG.DSL.Component
    end
  end

  defmacro defcomponent(name, do: block) do
    quote do
      defmodule ElixirRPG.ComponentTypes.unquote(name) do
        typedstruct do
          unquote(block)
        end
      end
    end
  end

  defmacro member(name, default_value) when is_atom(default_value) do
    quote do
      field(unquote(name), atom(), default: unquote(default_value))
    end
  end

  defmacro member(name, default_value) when is_boolean(default_value) do
    quote do
      field(unquote(name), boolean(), default: unquote(default_value))
    end
  end

  defmacro member(name, default_value) when is_integer(default_value) do
    quote do
      field(unquote(name), integer(), default: unquote(default_value))
    end
  end

  defmacro member(name, default_value) when is_float(default_value) do
    quote do
      field(unquote(name), float(), default: unquote(default_value))
    end
  end

  defmacro member(name, default_value) when is_binary(default_value) do
    quote do
      field(unquote(name), String.t(), default: unquote(default_value))
    end
  end

  defmacro member(name, default_value) when is_list(default_value) do
    quote do
      field(unquote(name), list(), default: unquote(default_value))
    end
  end

  defmacro member(name, default_value) when is_map(default_value) do
    quote do
      field(unquote(name), %{}, default: unquote(default_value))
    end
  end
end

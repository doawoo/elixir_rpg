defmodule ElixirRPG.ModUtil do
  def get_entity_types do
    {:ok, mods} = :application.get_key(:elixir_rpg, :modules)
    mods |> Enum.filter(fn mod ->
      parts = Module.split(mod)
      match?(["ElixirRPG", "EntityTypes" | _], parts)
    end)
  end

  def get_component_types do
    {:ok, mods} = :application.get_key(:elixir_rpg, :modules)
    mods |> Enum.filter(fn mod ->
      parts = Module.split(mod)
      match?(["ElixirRPG", "ComponentTypes" | _], parts)
    end)
  end

  def get_system_types do
    {:ok, mods} = :application.get_key(:elixir_rpg, :modules)
    mods |> Enum.filter(fn mod ->
      parts = Module.split(mod)
      match?(["ElixirRPG", "RuntimeSystems" | _], parts)
    end)
  end
end
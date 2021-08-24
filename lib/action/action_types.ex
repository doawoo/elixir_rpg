defmodule ElixirRPG.Action.ActionTypes do
  alias ElixirRPG.Action

  # Damange Types
  def physical_damage(target, power, pierce? \\ false) do
    Action.make_action(:dmg_phys, target, %{power: power, pierce?: pierce?})
  end

  def magic_damage(target, power, element \\ :no_element) do
    Action.make_action(:dmg_magic, target, %{power: power, element: element})
  end

  # Inflict Status
  def inflict_poison(target, turns \\ 3) do
    Action.make_action(:status_poison, target, %{turns: turns})
  end

  def inflict_sleep(target, turns \\ 3) do
    Action.make_action(:status_sleep, target, %{turns: turns})
  end
end

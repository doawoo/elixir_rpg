defmodule ElixirRPG.Action.ActionTypes do
  alias ElixirRPG.Action

  # Damange Types
  def physical_damage(target, power, pierce? \\ false) do
    Action.make_action(:dmg_phys, target, %{power: power, pierce?: pierce?})
  end

  def magic_damage(target, power, element \\ :no_element) do
    Action.make_action(:dmg_magic, target, %{power: power, element: element})
  end

  def heal(target, amount) do
    Action.make_action(:healing, target, %{amount: amount})
  end

  def restore_mp(target, amount) do
    Action.make_action(:restore_mp, target, %{amount: amount})
  end

  def give_status(target, effect) do
    Action.make_action(:give_status, target, %{effect: effect})
  end
end

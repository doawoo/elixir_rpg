defmodule ElixirRPG.Entity.EntityStore do
  def get_entities_with([single_want_list]) do
    :pg2.get_members(single_want_list)
  end

  def get_entities_with([first_want | want_list]) when is_list(want_list) do
    first_set =
      :pg2.get_members(first_want)
      |> MapSet.new()

    Enum.reduce(want_list, first_set, fn want, acc ->
      :pg2.get_members(want)
      |> MapSet.new()
      |> MapSet.intersection(acc)
    end)
  end
end

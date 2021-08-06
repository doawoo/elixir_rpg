defmodule ElixirRPG.Entity.EntityStore do
  def ensure_group_registered(group) when is_atom(group) do
    :pg2.create(group)
  end

  def add_entity_to_group(group, entity) when is_atom(group) and is_pid(entity) do
    ensure_group_registered(group)
    :pg2.join(group, entity)
  end

  def remove_entity_from_group(group, entity) when is_atom(group) and is_pid(entity) do
    :pg2.leave(group, entity)
  end

  def get_entities_with([single_want_list]) do
    :pg2.get_members(single_want_list)
  end

  def get_entities_with(want_list) when is_list(want_list) do
    all_wants =
      Enum.map(want_list, fn want ->
        :pg2.get_members(want) |> :sets.from_list()
      end)

    :sets.intersection(all_wants) |> :sets.to_list()
  end
end

defmodule ElixirRPG.Entity.EntityStore do
  def add_entity_to_group(group, world_name, entity) when is_atom(group) and is_pid(entity) do
    full_name = Module.concat(world_name, group)
    IO.inspect("add to #{full_name}")
    :pg2.create(full_name)
    :pg2.join(full_name, entity)
  end

  def remove_entity_from_group(group, world_name, entity)
      when is_atom(group) and is_pid(entity) do
    full_name = Module.concat(world_name, group)
    :pg2.leave(full_name, entity)
  end

  def get_entities_with([single_want_list], world_name) do
    full_name = Module.concat(world_name, single_want_list)
    :pg2.get_members(full_name)
  end

  def get_entities_with(want_list, world_name) when is_list(want_list) do
    all_wants =
      Enum.map(want_list, fn want ->
        full_name = Module.concat(world_name, want)
        :pg2.get_members(full_name) |> :sets.from_list()
      end)

    :sets.intersection(all_wants) |> :sets.to_list()
  end
end

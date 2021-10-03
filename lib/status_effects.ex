defmodule ElixirRPG.StatusEffects do
  use TypedStruct
  alias ElixirRPG.Entity

  alias __MODULE__

  typedstruct do
    field :interval, number(), enforce: true, default: -1
    field :max_duration, number(), enforce: true, default: -1
    field :on_inflict, (pid() -> :ok), enforce: true, default: nil
    field :on_applied, (pid() -> :ok), enforce: true, default: nil
    field :on_removed, (pid() -> :ok), enforce: true, default: nil
  end

  def poison do
    %StatusEffects{
      interval: 5.0,
      max_duration: -1.0,
      on_inflict: (fn entity ->
        IO.inspect("poison apply")
        curr_hp = Entity.get_component(entity, DemoStats).hp
        inflict_dmg = 3.0
        Entity.set_component_data(entity, DemoStats, :hp, curr_hp - inflict_dmg)
      end),
      on_applied: nil,
      on_removed: nil
    }
  end

  def burn do
    %StatusEffects{
      interval: 1.0,
      max_duration: 10.0,
      on_inflict: (fn entity ->
        curr_hp = Entity.get_component(entity, DemoStats).hp
        inflict_dmg = 2.0
        Entity.set_component_data(entity, DemoStats, :hp, curr_hp - inflict_dmg)
      end),
      on_applied: nil,
      on_removed: nil
    }
  end

  def coffee_up do
    %StatusEffects{
      interval: -1.0,
      max_duration: 10.0,
      on_inflict: nil,
      on_applied: nil,
      on_removed: nil
    }
  end
end

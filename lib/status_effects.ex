defmodule ElixirRPG.StatusEffects do
  use TypedStruct
  alias ElixirRPG.Entity
  alias ElixirRPG.RuntimeSystems.StatusEffectSystem

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
      on_inflict: fn entity ->
        inflict_dmg = 3.0
        curr_hp = Entity.get_component(entity, DemoStats).hp
        Entity.set_component_data(entity, DemoStats, :hp, curr_hp - inflict_dmg)
      end,
      on_applied: nil,
      on_removed: nil
    }
  end

  def burn do
    %StatusEffects{
      interval: 1.0,
      max_duration: 10.0,
      on_inflict: fn entity ->
        inflict_dmg = 2.0
        curr_hp = Entity.get_component(entity, DemoStats).hp
        Entity.set_component_data(entity, DemoStats, :hp, curr_hp - inflict_dmg)
      end,
      on_applied: nil,
      on_removed: nil
    }
  end

  @doc """
  Boosts the speed of the ATB bar
  """
  def coffee_up do
    %StatusEffects{
      interval: -1.0,
      max_duration: 5.0,
      on_inflict: nil,
      on_applied: fn _entity ->
        IO.inspect("coffee_up applied!")
      end,
      on_removed: fn entity ->
        IO.inspect("coffee_up removed!")
        StatusEffectSystem.add_status_to_entity(entity, :coffee_down)
      end
    }
  end

  @doc """
  Lessens the speed of the ATB bar
  """
  def coffee_down do
    %StatusEffects{
      interval: -1.0,
      max_duration: 5.0,
      on_inflict: nil,
      on_applied: fn _entity ->
        IO.inspect("coffee_down applied!")
      end,
      on_removed: fn _entity ->
        IO.inspect("coffee_down removed!")
      end
    }
  end
end

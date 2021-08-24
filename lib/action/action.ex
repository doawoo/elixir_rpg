defmodule ElixirRPG.Action do
  use TypedStruct

  require Logger

  alias __MODULE__

  typedstruct do
    field :action_type, atom(), enforce: true
    field :target_entity, pid(), enforce: true
    field :payload, %{}, enforce: true
  end

  def make_action(type, target, extra_data \\ %{}) do
    %Action{
      action_type: type,
      target_entity: target,
      payload: extra_data
    }
  end

  def execute(%Action{} = action) do
    if Process.alive?(action.target_entity) do
      Logger.debug("Action enqueued: #{inspect(action)}")
      GenServer.call(action.target_entity, {:action_recv, action})
    else
      Logger.warn("Action was dropped because target PID was dead: #{inspect(action)}")
    end
  end
end

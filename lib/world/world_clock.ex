defmodule ElixirRPG.World.Clock do
  def start_tick(target_ticks_per_sec, target_pid)
      when is_pid(target_pid) and is_integer(target_ticks_per_sec) do
    ms = trunc(1000 / target_ticks_per_sec)
    {:ok, timer_ref} = :timer.send_interval(ms, target_pid, :tick)
    timer_ref
  end
end
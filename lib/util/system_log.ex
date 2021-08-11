defmodule ElixirRPG.Util.SystemLog do
  require Logger

  def debug(item) do
    if System.get_env("DEBUG") != nil do
      Logger.debug("#{inspect(item)}")
    end
  end
end

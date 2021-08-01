use ElixirRPG.DSL.System

defsystem TestSystem do

  name "A Simple Testing System"

  wants :player_stats
  wants :input

  on_tick do
    IO.inspect("tick")
  end
end
use ElixirRPG.DSL.System

defsystem PlayerInput do
  require Logger

  alias ElixirRPG.World.Input

  name "PlayerInputSystem"

  wants ActorName
  wants ActorStats
  wants PlayerInput
  wants ActiveBattle

  on_tick do
    can_move? = get_component_data(ActiveBattle, :ready)

    # 1. Able to move?
    # 2. Have an input to consume?
    # 3. Input is for us?
    with true <- can_move?,
         ## TODO GenServer it calling itself here so we probably need an input genserver, not the world!
         %Input{} = input <- GenServer.call(world_name, :peek_input),
         true <- entity == input.target_character do
      GenServer.call(world_name, :consume_input) |> process_input()
    else
      _ -> :ok
    end
  end

  defp process_input(%Input{} = input_struct) do
    Logger.info(
      "Executing pending input: #{inspect(input_struct.target_character)} #{
        inspect(input_struct.input_paramters)
      }"
    )
  end
end

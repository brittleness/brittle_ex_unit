defmodule SystemMock do
  require Logger

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def with(mock, command, result, fun) do
    put(mock, command, result)
    fun.()
    delete(mock, command)
  end

  def put(mock, command, result) do
    Agent.update(mock, &Map.put(&1, command, result))
  end

  def delete(mock, command) do
    Agent.update(mock, &Map.delete(&1, command))
  end

  def cmd("hostname" = cmd, [] = args) do
    execute_command_and_replace_result(
      {cmd, args},
      "Alices-MBP.fritz.box\n"
    )
  end

  def cmd("git" = cmd, ~w(rev-parse --abbrev-ref HEAD) = args) do
    execute_command_and_replace_result(
      {cmd, args},
      "develop\n"
    )
  end

  def cmd("git" = cmd, ~w(rev-parse HEAD) = args) do
    execute_command_and_replace_result(
      {cmd, args},
      "7f8136915fe249efa47a21a89ff0f04e880264fc\n"
    )
  end

  def cmd("git" = cmd, ~w(status --porcelain) = args) do
    execute_command_and_replace_result({cmd, args}, "")
  end

  defp execute_command_and_replace_result({cmd, args} = command, replacement) do
    case System.cmd(cmd, args) do
      {_, 0} ->
        {get(command) || replacement, 0}

      result ->
        Logger.warn(
          "SystemMock called `System.cmd(#{inspect(cmd)}, #{inspect(args)})` " <>
            "and expected `{_, 0}`, but received `#{inspect(result)}`."
        )

        result
    end
  end

  defp get(command) do
    case Process.whereis(__MODULE__) do
      nil -> nil
      _ -> Agent.get(__MODULE__, &Map.get(&1, command))
    end
  end
end

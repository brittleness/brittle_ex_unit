defmodule SystemMock do
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def put(mock, command, result) do
    Agent.update(mock, &Map.put(&1, command, result))
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
    execute_command_and_replace_result(
      {cmd, args},
      " M lib/system_data.ex\n"
    )
  end

  defp execute_command_and_replace_result({cmd, args} = command, replacement) do
    case System.cmd(cmd, args) do
      {_, 0} -> {get(command) || replacement, 0}
      result -> result
    end
  end

  defp get(command) do
    case Process.whereis(__MODULE__) do
      nil -> nil
      _ -> Agent.get(__MODULE__, &Map.get(&1, command))
    end
  end
end

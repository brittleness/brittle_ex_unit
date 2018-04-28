defmodule SystemMock do
  def start_link do
    Agent.start_link(
      fn ->
        %{
          {"git", ~w(status --porcelain)} => " M lib/system_data.ex\n"
        }
      end,
      name: __MODULE__
    )
  end

  def set(mock, command, result) do
    Agent.update(mock, &Map.put(&1, command, result))
  end

  def cmd("hostname", []) do
    case System.cmd("hostname", []) do
      {_, 0} -> {"Alices-MBP.fritz.box\n", 0}
      result -> result
    end
  end

  def cmd("git", ~w(rev-parse --abbrev-ref HEAD)) do
    case System.cmd("git", ~w(rev-parse --abbrev-ref HEAD)) do
      {_, 0} -> {"develop\n", 0}
      result -> result
    end
  end

  def cmd("git", ~w(rev-parse HEAD)) do
    case System.cmd("git", ~w(rev-parse HEAD)) do
      {_, 0} -> {"7f8136915fe249efa47a21a89ff0f04e880264fc\n", 0}
      result -> result
    end
  end

  def cmd("git", ~w(status --porcelain)) do
    case System.cmd("git", ~w(status --porcelain)) do
      {_, 0} ->
        {
          Agent.get(__MODULE__, &Map.get(&1, {"git", ~w(status --porcelain)})),
          0
        }
      result -> result
    end
  end
end

defmodule SystemMock do
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
end

defmodule SystemMock do
  def cmd("hostname", []) do
    case System.cmd("hostname", []) do
      {_, 0} -> {"Alices-MBP.fritz.box\n", 0}
      result -> result
    end
  end
end

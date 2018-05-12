defmodule Brittle.ExUnitData do
  def module(%{module: module}), do: module

  def module(%{case: module}), do: module
end

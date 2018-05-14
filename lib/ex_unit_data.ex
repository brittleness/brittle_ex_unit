defmodule Brittle.ExUnitData do
  @moduledoc """
  Convenience functions for retrieving data from `ExUnit.Test` structs.
  """

  def module(%{module: module}), do: module

  def module(%{case: module}), do: module

  def file(%{tags: %{file: file}}) do
    Path.relative_to(file, File.cwd!())
  end
end

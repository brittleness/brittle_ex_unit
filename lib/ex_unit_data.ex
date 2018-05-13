defmodule Brittle.ExUnitData do
  def module(%{module: module}), do: module

  def module(%{case: module}), do: module

  def file(%{tags: %{file: file}}) do
    Path.relative_to(file, File.cwd!)
  end
end

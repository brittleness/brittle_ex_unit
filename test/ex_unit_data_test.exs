defmodule Brittle.ExUnitDataTest do
  use ExUnit.Case, async: true
  alias Brittle.ExUnitData

  test "module/1 returns the test's module name when it has a module key" do
    assert ExUnitData.module(%{module: ExampleTest}) == ExampleTest
  end

  test "module/1 returns the test's module name when it only has a case key" do
    assert ExUnitData.module(%{case: ExampleTest}) == ExampleTest
  end
end

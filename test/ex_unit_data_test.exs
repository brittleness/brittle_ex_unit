defmodule Brittle.ExUnitDataTest do
  use ExUnit.Case, async: true
  alias Brittle.ExUnitData

  test "module/1 returns the test's module name when it has a module key" do
    assert ExUnitData.module(%{module: ExampleTest}) == ExampleTest
  end

  test "module/1 returns the test's module name when it only has a case key" do
    assert ExUnitData.module(%{case: ExampleTest}) == ExampleTest
  end

  test "file/1 returns the test's relative file name", %{file: file} do
    assert ExUnitData.file(%{tags: %{file: file}}) ==
             "test/ex_unit_data_test.exs"
  end
end

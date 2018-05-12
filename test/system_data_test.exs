defmodule Brittle.SystemDataTest do
  use ExUnit.Case, async: true
  alias Brittle.SystemData

  setup do
    {:ok, system_mock} = SystemMock.start_link
    [system_mock: system_mock]
  end

  test "hostname/0 finds the hostname" do
    assert SystemData.hostname == "Alices-MBP.fritz.box"
  end

  test "branch/0 finds the branch" do
    assert SystemData.branch == "develop"
  end

  test "revision/0 finds the revision" do
    assert SystemData.revision == "7f8136915fe249efa47a21a89ff0f04e880264fc"
  end

  describe "with a clean working directory" do
    setup %{system_mock: system_mock} do
      SystemMock.put(system_mock, {"git", ~w(status --porcelain)}, "")
    end

    test "dirty?/0 returns false" do
      assert SystemData.dirty? == false
    end
  end

  describe "with a dirty working directory" do
    test "dirty?/0 returns true" do
      assert SystemData.dirty? == true
    end
  end
end

defmodule Brittle.SystemDataTest do
  use ExUnit.Case, async: true
  alias Brittle.SystemData

  setup do
    {:ok, system_mock} = SystemMock.start_link

    ExUnit.Callbacks.on_exit(fn() ->
      ref = Process.monitor(system_mock)
      assert_receive {:DOWN, ^ref, _, _, _}, 500
    end)

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

  test "dirty?/0 returns false with a clean working directory" do
    assert SystemData.dirty?() == false
  end

  test "dirty?/0 returns true with a dirty working directory", %{system_mock: system_mock} do
    SystemMock.with(system_mock, {"git", ~w(status --porcelain)}, " M lib/system_data.ex\n", fn ->
      assert SystemData.dirty?() == true
    end)
  end
end

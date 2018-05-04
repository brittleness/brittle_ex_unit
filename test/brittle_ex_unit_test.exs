defmodule Brittle.ExUnitTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = GenServer.start_link(Brittle.ExUnit, [])

    [pid: pid]
  end

  test "counts tests, excludes and failures, records durations", %{pid: pid} do
    GenServer.cast(pid, {:test_finished, %ExUnit.Test{}})
    GenServer.cast(pid, {:test_finished, %ExUnit.Test{state: {:failed, []}}})
    GenServer.cast(pid, {:test_finished, %ExUnit.Test{state: {:excluded, ""}}})
    GenServer.cast(pid, {:suite_finished, 69251, 0})

    state = :sys.get_state(pid)
    assert state.suite == %{name: "brittle_ex_unit"}
    assert state.hostname == "Alices-MBP.fritz.box"
    assert state.branch == "develop"
    assert state.revision == "7f8136915fe249efa47a21a89ff0f04e880264fc"
    assert state.dirty == true
    assert state.test_count == 3
    assert state.failure_count == 1
    assert state.excluded_count == 1
    assert state.duration == 69251
  end

  test "handles unmatching clauses", %{pid: pid} do
    :sys.replace_state(pid, fn _ -> %{} end)
    GenServer.cast(pid, :no_clause_matching)

    assert :sys.get_state(pid) == %{}
  end

  test "stores the payload in the payloads directory", %{pid: pid} do
    GenServer.cast(pid, {:suite_finished, 92516, 0})
    :sys.get_state(pid)

    payload =
      :brittle_ex_unit
      |> Application.get_env(:payload_directory)
      |> Path.join("1525466659652251.json")
      |> File.read!()
      |> Jason.decode!(keys: :atoms!)

    assert payload.duration == 92516
  end
end

defmodule Brittle.ExUnitTest do
  use ExUnit.Case

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
    assert state.hostname == "Alices-MBP.fritz.box"
    assert state.branch == "develop"
    assert state.revision == "7f8136915fe249efa47a21a89ff0f04e880264fc"
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
end

defmodule Brittle.ExUnitTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = GenServer.start_link(Brittle.ExUnit, [])

    [pid: pid, state: %{test_count: 2, failure_count: 1, duration: 69251}]
  end

  test "counts tests and failures, records durations", %{pid: pid, state: state} do
    GenServer.cast(pid, {:test_finished, %ExUnit.Test{}})
    GenServer.cast(pid, {:test_finished, %ExUnit.Test{state: {:failed, []}}})
    GenServer.cast(pid, {:suite_finished, 69251, 0})

    assert :sys.get_state(pid) == state
  end

  test "handles unmatching clauses", %{pid: pid, state: state} do
    :sys.replace_state(pid, fn _ -> state end)
    GenServer.cast(pid, :no_clause_matching)

    assert :sys.get_state(pid) == state
  end
end

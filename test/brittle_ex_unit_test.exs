defmodule Brittle.ExUnitTest do
  use ExUnit.Case

  test "counts tests and failures" do
    {:ok, pid} = GenServer.start_link(Brittle.ExUnit, [])

    GenServer.cast(pid, {:test_finished, %ExUnit.Test{}})
    GenServer.cast(pid, {:test_finished, %ExUnit.Test{state: {:failed, []}}})

    assert :sys.get_state(pid) == %{test_count: 2, failure_count: 1}
  end
end

defmodule Brittle.ExUnitTest do
  use ExUnit.Case

  test "counts tests" do
    {:ok, pid} = GenServer.start_link(Brittle.ExUnit, [])

    GenServer.cast(pid, {:test_finished, %ExUnit.Test{}})

    assert :sys.get_state(pid) == %{test_count: 1}
  end
end

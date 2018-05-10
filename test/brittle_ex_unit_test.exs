defmodule Brittle.ExUnitTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = GenServer.start_link(Brittle.ExUnit, [])
    {:ok, date_time} = DateTimeMock.start_link()

    [pid: pid, date_time: date_time]
  end

  test "counts tests, excludes and failures, records durations", %{pid: pid, date_time: date_time} do
    GenServer.cast(pid, {:suite_started, []})
    :sys.get_state(pid)
    DateTimeMock.pass_time(date_time, 69251)

    GenServer.cast(
      pid,
      {:test_finished,
       %ExUnit.Test{
         module: ExampleTest,
         name: :"test passes",
         time: 23132
       }}
    )

    GenServer.cast(
      pid,
      {:test_finished,
       %ExUnit.Test{
         module: ExampleTest,
         name: :"test fails",
         time: 24123,
         state: {:failed, []}
       }}
    )

    GenServer.cast(
      pid,
      {:test_finished,
       %ExUnit.Test{
         module: ExampleTest,
         name: :"test is excluded",
         time: 21996,
         state: {:excluded, ""}
       }}
    )

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
    assert state.started_at == DateTime.from_naive!(~N[2018-05-04 20:44:19.652251], "Etc/UTC")
    assert state.finished_at == DateTime.from_naive!(~N[2018-05-04 20:44:19.721502], "Etc/UTC")

    assert state.results == [
             %{
               status: :passed,
               duration: 23132,
               test: %{module: ExampleTest, name: :"test passes"}
             },
             %{
               status: :failed,
               duration: 24123,
               test: %{module: ExampleTest, name: :"test fails"}
             },
             %{
               status: :excluded,
               duration: 21996,
               test: %{module: ExampleTest, name: :"test is excluded"}
             }
           ]
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

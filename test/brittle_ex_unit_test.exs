defmodule Brittle.ExUnitTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = GenServer.start_link(Brittle.ExUnit, [])
    {:ok, date_time} = DateTimeMock.start_link()

    ExUnit.Callbacks.on_exit(fn ->
      ref = Process.monitor(date_time)
      assert_receive {:DOWN, ^ref, _, _, _}, 500
    end)

    [pid: pid, date_time: date_time]
  end

  test "counts tests, excludes and failures, records durations", %{
    pid: pid,
    date_time: date_time,
    file: file
  } do
    GenServer.cast(pid, {:suite_started, []})
    :sys.get_state(pid)
    DateTimeMock.pass_time(date_time, 69_251)

    module = %{
      module_or_case() => ExampleTest
    }

    GenServer.cast(
      pid,
      {:test_finished,
       Map.merge(
         %ExUnit.Test{name: :"test passes", time: 23_132, tags: %{file: file, line: 12}},
         module
       )}
    )

    GenServer.cast(
      pid,
      {:test_finished,
       Map.merge(
         %ExUnit.Test{
           name: :"test fails",
           time: 24_123,
           tags: %{file: file, line: 23},
           state: {:failed, []}
         },
         module
       )}
    )

    GenServer.cast(
      pid,
      {:test_finished,
       Map.merge(
         %ExUnit.Test{
           name: :"test is excluded",
           time: 21_996,
           tags: %{file: file, line: 34},
           state: {:excluded, ""}
         },
         module
       )}
    )

    GenServer.cast(pid, {:suite_finished, 69_251, 0})

    state = :sys.get_state(pid)
    assert state.suite == %{name: "brittle_ex_unit"}
    assert state.hostname == "Alices-MBP.fritz.box"
    assert state.branch == "develop"
    assert state.revision == "7f8136915fe249efa47a21a89ff0f04e880264fc"
    assert state.dirty == false
    assert state.test_count == 3
    assert state.failure_count == 1
    assert state.excluded_count == 1
    assert state.duration == 69_251
    assert state.started_at == DateTime.from_naive!(~N[2018-05-04 20:44:19.652251], "Etc/UTC")
    assert state.finished_at == DateTime.from_naive!(~N[2018-05-04 20:44:19.721502], "Etc/UTC")

    assert state.results == [
             %{
               status: :passed,
               duration: 23_132,
               test: %{
                 module: ExampleTest,
                 name: :"test passes",
                 file: "test/brittle_ex_unit_test.exs",
                 line: 12
               }
             },
             %{
               status: :failed,
               duration: 24_123,
               test: %{
                 module: ExampleTest,
                 name: :"test fails",
                 file: "test/brittle_ex_unit_test.exs",
                 line: 23
               }
             },
             %{
               status: :excluded,
               duration: 21_996,
               test: %{
                 module: ExampleTest,
                 name: :"test is excluded",
                 file: "test/brittle_ex_unit_test.exs",
                 line: 34
               }
             }
           ]
  end

  test "handles unmatching clauses", %{pid: pid} do
    :sys.replace_state(pid, fn _ -> %{} end)
    GenServer.cast(pid, :no_clause_matching)

    assert :sys.get_state(pid) == %{}
  end

  test "stores the payload in the payloads directory", %{pid: pid} do
    GenServer.cast(pid, {:suite_finished, 92_516, 0})
    :sys.get_state(pid)

    payload =
      :brittle_ex_unit
      |> Application.get_env(:payload_directory)
      |> Path.join("1525466659652251.json")
      |> File.read!()
      |> Jason.decode!(keys: :atoms!)

    assert payload.duration == 92_516
  end

  defp module_or_case do
    case Map.has_key?(%ExUnit.Test{}, :module) do
      true -> :module
      false -> :case
    end
  end
end

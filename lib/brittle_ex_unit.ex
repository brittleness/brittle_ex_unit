defmodule Brittle.ExUnit do
  @moduledoc """
  An ExUnit reporter that records test run statistics and writes the data to a
  payload file as JSON.
  """

  alias Brittle.{SystemData, ExUnitData}
  @date_time Application.get_env(:brittle_ex_unit, :date_time, DateTime)
  @json_encoder Application.get_env(:brittle_ex_unit, :json_encoder, Jason)

  def init(_) do
    {:ok,
     %{
       test_count: 0,
       failure_count: 0,
       excluded_count: 0,
       duration: 0,
       suite: %{name: Atom.to_string(Mix.Project.config()[:app])},
       hostname: SystemData.hostname(),
       branch: SystemData.branch(),
       revision: SystemData.revision(),
       dirty: SystemData.dirty?(),
       started_at: nil,
       finished_at: nil,
       results: []
     }}
  end

  def handle_cast({:suite_started, _}, state) do
    state = %{state | started_at: @date_time.utc_now()}

    {:noreply, state}
  end

  def handle_cast({:test_finished, test}, state) do
    state =
      case status(test) do
        :passed -> state
        :excluded -> %{state | excluded_count: state.excluded_count + 1}
        :failed -> %{state | failure_count: state.failure_count + 1}
      end

    state = %{
      state
      | test_count: state.test_count + 1,
        results: add_result(state.results, test)
    }

    {:noreply, state}
  end

  def handle_cast({:suite_finished, duration, _}, state) do
    state = %{state | duration: duration, finished_at: @date_time.utc_now()}

    File.mkdir_p!(payload_directory())
    File.write!(filename(), @json_encoder.encode!(state))

    {:noreply, state}
  end

  def handle_cast(_, state) do
    {:noreply, state}
  end

  def terminate(_, _), do: :ok

  defp add_result(results, %ExUnit.Test{name: name, time: duration} = test) do
    results ++
      [
        %{
          status: status(test),
          duration: duration,
          test: %{
            name: name,
            module: ExUnitData.module(test),
            file: ExUnitData.file(test),
            line: test.tags.line
          }
        }
      ]
  end

  defp status(%ExUnit.Test{state: {status, _}}), do: status
  defp status(%ExUnit.Test{state: nil}), do: :passed

  defp payload_directory do
    Application.get_env(
      :brittle_ex_unit,
      :payload_directory,
      Path.join(System.user_home!(), ".brittle/payloads")
    )
  end

  defp filename do
    basename =
      @date_time.utc_now()
      |> DateTime.to_unix(:microsecond)
      |> Integer.to_string()

    Path.join(payload_directory(), basename <> ".json")
  end
end

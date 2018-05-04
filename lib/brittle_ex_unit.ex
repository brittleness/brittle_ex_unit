defmodule Brittle.ExUnit do
  alias Brittle.SystemData

  def init(_) do
    {:ok,
     %{
       test_count: 0,
       failure_count: 0,
       excluded_count: 0,
       duration: 0,
       suite: Atom.to_string(Mix.Project.config()[:app]),
       hostname: SystemData.hostname(),
       branch: SystemData.branch(),
       revision: SystemData.revision(),
       dirty: SystemData.dirty?()
     }}
  end

  def handle_cast({:test_finished, %ExUnit.Test{state: {:failed, _}}}, state) do
    state = %{state | test_count: state.test_count + 1, failure_count: state.failure_count + 1}

    {:noreply, state}
  end

  def handle_cast({:test_finished, %ExUnit.Test{state: {:excluded, _}}}, state) do
    state = %{state | test_count: state.test_count + 1, excluded_count: state.excluded_count + 1}

    {:noreply, state}
  end

  def handle_cast({:test_finished, %ExUnit.Test{state: nil}}, state) do
    {:noreply, %{state | test_count: state.test_count + 1}}
  end

  def handle_cast({:suite_finished, duration, _}, state) do
    {:noreply, %{state | duration: duration}}
  end

  def handle_cast(_, state) do
    {:noreply, state}
  end
end

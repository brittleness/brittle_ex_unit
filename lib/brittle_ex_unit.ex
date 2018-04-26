defmodule Brittle.ExUnit do
  def init(_) do
    {:ok, %{test_count: 0, failure_count: 0, duration: 0}}
  end

  def handle_cast({:test_finished, %ExUnit.Test{state: {:failed, _}}}, state) do
    {
      :noreply,
      %{state | test_count: state.test_count + 1, failure_count: state.failure_count + 1}
    }
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

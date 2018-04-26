defmodule Brittle.ExUnit do
  def init(_) do
    {:ok, %{test_count: 0}}
  end

  def handle_cast({:test_finished, _}, state) do
    {:noreply, %{state | test_count: state.test_count + 1}}
  end
end

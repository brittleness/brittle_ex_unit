defmodule DateTimeMock do
  @moduledoc """
  A mock for Elixir's `DateTime`. Has a static time that can be changed if
  needed.
  """

  @default ~N[2018-05-04 20:44:19.652251]

  def start_link do
    Agent.start_link(fn -> %{utc_now: @default} end, name: __MODULE__)
  end

  def pass_time(mock, us) do
    Agent.update(mock, fn state ->
      {_, state} =
        Map.get_and_update!(state, :utc_now, fn utc_now ->
          {utc_now, NaiveDateTime.add(utc_now, us, :microsecond)}
        end)

      state
    end)
  end

  def utc_now do
    naive =
      case Process.whereis(__MODULE__) do
        nil ->
          @default

        _ ->
          Agent.get(__MODULE__, &Map.get(&1, :utc_now))
      end

    DateTime.from_naive!(naive, "Etc/UTC")
  end
end

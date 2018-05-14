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
    __MODULE__
    |> Agent.get(&Map.get(&1, :utc_now))
    |> DateTime.from_naive!("Etc/UTC")
  end
end

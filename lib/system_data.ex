defmodule Brittle.SystemData do
  @moduledoc """
  Wraps commands to Elixir's `System` module to retreive system data.
  """

  @system Application.get_env(:brittle_ex_unit, :system, System)

  def hostname do
    {hostname, 0} = @system.cmd("hostname", [])
    String.trim(hostname)
  end

  def branch do
    {branch, 0} = @system.cmd("git", ~w(rev-parse --abbrev-ref HEAD))
    String.trim(branch)
  end

  def revision do
    {revision, 0} = @system.cmd("git", ~w(rev-parse HEAD))
    String.trim(revision)
  end

  def dirty? do
    {status, 0} = @system.cmd("git", ~w(status --porcelain))
    status != ""
  end
end

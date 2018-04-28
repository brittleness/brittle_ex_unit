defmodule Brittle.SystemData do
  @system Application.get_env(:brittle_ex_unit, :system, System)

  def hostname do
    {hostname, 0} = @system.cmd("hostname", [])
    String.trim(hostname)
  end
end

defmodule Brittle.SystemDataTest do
  use ExUnit.Case
  alias Brittle.SystemData

  test "hostname/0 finds the hostname" do
    assert SystemData.hostname == "Alices-MBP.fritz.box"
  end

  test "branch/0 finds the branch" do
    assert SystemData.branch == "develop"
  end
end

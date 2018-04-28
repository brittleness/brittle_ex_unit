defmodule Brittle.SystemDataTest do
  use ExUnit.Case
  alias Brittle.SystemData

  test "hostname/0 finds the hostname" do
    assert SystemData.hostname == "Alices-MBP.fritz.box"
  end

  test "branch/0 finds the branch" do
    assert SystemData.branch == "develop"
  end

  test "revision/0 finds the revision" do
    assert SystemData.revision == "7f8136915fe249efa47a21a89ff0f04e880264fc"
  end
end

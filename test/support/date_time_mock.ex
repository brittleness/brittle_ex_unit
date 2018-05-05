defmodule DateTimeMock do
  def utc_now() do
    DateTime.from_naive!(~N[2018-05-04 20:44:19.652251], "Etc/UTC")
  end
end

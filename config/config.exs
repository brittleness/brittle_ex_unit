use Mix.Config

config :brittle_ex_unit,
  payload_directory: "_build/test/payloads/#{Enum.random(100..999)}",
  date_time: DateTimeMock,
  system: SystemMock

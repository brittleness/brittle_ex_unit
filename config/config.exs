use Mix.Config

config :brittle_ex_unit,
  payload_directory: "#{System.tmp_dir!()}#{:random.uniform(999)}",
  date_time: DateTimeMock,
  system: SystemMock

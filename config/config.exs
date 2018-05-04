use Mix.Config

config :brittle_ex_unit,
  payload_directory: "#{System.tmp_dir!()}#{:random.uniform(999)}",
  naive_date_time: NaiveDateTimeMock,
  system: SystemMock

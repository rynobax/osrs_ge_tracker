# Jobs are defined in config.exs

defmodule OsrsGeTracker.Scheduler do
  use Quantum.Scheduler, otp_app: :osrs_ge_tracker
end

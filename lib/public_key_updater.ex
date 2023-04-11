defmodule FirebaseJwt.PublicKeyUpdater do
  use Task, restart: :permanent
  require Logger
  alias FirebaseJwt.PublicKeyStore
  # @fetch_interval 300_000

  def start_link([]) do
    Task.start_link(__MODULE__, :run, [])
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def run() do
    # Allow endless restart
    :timer.sleep(1000)
    Application.get_env(:firebase_jwt, :debug_log) && Logger.debug("[#{__MODULE__}] runs.")

    PublicKeyStore.fetch_firebase_keys()
    expire = PublicKeyStore.get(:expire) |> DateTime.to_unix(:millisecond)
    now = Timex.now() |> DateTime.to_unix(:millisecond)
    interval = ceil((expire - now) * 0.8)
    # :timer.sleep(@fetch_interval)
    :timer.sleep(interval)

    run()
  end
end

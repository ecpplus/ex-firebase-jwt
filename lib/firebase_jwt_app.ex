defmodule FirebaseJwt.App do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(FirebaseJwt.PublicKeyStore, []),
      worker(FirebaseJwt.PublicKeyUpdater, [])
    ]

    {:ok, _} = Supervisor.start_link(children, strategy: :one_for_one)
  end
end

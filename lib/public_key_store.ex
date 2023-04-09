defmodule FirebaseJwt.PublicKeyStore do
  @googleCertificateUrl "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"

  use GenServer
  require Logger

  def start_link([]) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def fetch_firebase_keys() do
    response = HTTPoison.get!(@googleCertificateUrl)
    {_, expire} = Enum.find(response.headers, fn {k, _} -> String.downcase(k) == "expires" end)

    store(:public_keys, Jason.decode!(response.body))
    store(:expire, Timex.parse!(expire, "{RFC1123}"))
  end

  def store(key, value) do
    GenServer.cast(__MODULE__, {:store, key, value})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:lookup, key})
  end

  def get_public_key(key_id) do
    case get(:public_keys) |> Map.get(key_id) do
      nil ->
        fetch_firebase_keys()
        get(:public_keys) |> Map.get(key_id)

      public_key ->
        public_key
    end
  end

  def handle_cast({:store, key, value}, state) do
    {:noreply, state |> Map.put(key, value)}
  end

  def handle_call({:lookup, key}, _from, state) do
    {:reply, state[key], state}
  end
end

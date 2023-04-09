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
    with {:ok, response = %HTTPoison.Response{status_code: 200}} <- HTTPoison.get(@googleCertificateUrl),
      {_, expires_string} <- Enum.find(response.headers, fn {key, _} -> String.match?(key, ~r/\Aexpires\z/i) end),
      {:ok, expire} <- Timex.parse(expires_string, "{RFC1123}") do
        store(:public_keys, Jason.decode!(response.body))
        store(:expire, expire)
        Logger.debug("#{__MODULE__} stored public_keys of Firebase.")

    else
      {:ok, response = %HTTPoison.Response{}} ->
        Logger.debug("Error fetching public keys: #{inspect(response)}")

      {:error, error} ->
        Logger.debug("Error fetching public keys: #{inspect(error)}")
    end
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

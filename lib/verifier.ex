defmodule FirebaseJwt.Verifier do
  @moduledoc """
  a module that verifies JWT from Firebase

  Specificaiton:
  https://firebase.google.com/docs/auth/admin/verify-id-tokens?hl=ja
  """
  alias FirebaseJwt.PublicKeyStore
  alias JOSE.{JWK, JWT}

  def verify(token) do
    case Application.get_env(:firebase_jwt, :simulator_mode) do
      true -> verify_without_signing(token)
      _ -> verify_with_signing(token)
    end
  end

  defp verify_without_signing(token) do
    with {:ok, payload} <- token |> String.split(".") |> Enum.at(1) |> Base.decode64(padding: false),
         {:ok, json} <- Jason.decode(payload) do
      {:ok, json}
    else
      _ -> {:error, :invalid_token}
    end
  end

  defp verify_with_signing(token) do
    case(pem(token)) do
      nil ->
        {:error, :unknown_public_key}

      pem ->
        with {true, %JWT{fields: claims}, _} <- JWT.verify_strict(jwk(pem), ["RS256"], token) do
          {:ok, claims}
        else
          _ -> {:error, :signature_error}
        end
    end
  end

  defp jwk(pem) do
    JWK.from_pem(pem)
  end

  defp firebase_public_key_id(token) do
    %{fields: %{"kid" => kid}} = JWT.peek_protected(token)
    kid
  end

  defp pem(token) do
    token
    |> firebase_public_key_id()
    |> PublicKeyStore.get_public_key()
  end
end

defmodule FirebaseJwt.Verifier do
  @moduledoc """
  a module that verifies JWT from Firebase

  Specificaiton:
  https://firebase.google.com/docs/auth/admin/verify-id-tokens?hl=ja
  """
  alias FirebaseJwt.PublicKeyStore
  alias JOSE.{JWK, JWT}

  def verify(token) do
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

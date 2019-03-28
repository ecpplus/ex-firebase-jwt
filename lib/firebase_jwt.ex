defmodule FirebaseJwt do
  @moduledoc """

  ## Example

  ### With valid token

    iex> FirebaseJwt.verify(json_web_token_string)

      {:ok,
       %{
         "aud" => "your-project",
         "auth_time" => 1553858461,
         "email" => "you@example.com",
         "email_verified" => true,
         "exp" => 1553862061,
         "firebase" => %{
           "identities" => %{
             "email" => ["you@example.com"],
             "google.com" => ["1234567890"]
           },
           "sign_in_provider" => "google.com"
         },
         "iat" => 1553858461,
         "iss" => "https://securetoken.google.com/your-project",
         "name" => "Your Name",
         "picture" => "https://example.com/you.jpg",
         "sub" => "fedcba0987654321",
         "user_id" => "1234567890abcdef"
       }}

  ### With invalid token

    iex> FirebaseJwt.verify(json_web_token_string)

      {:error, nil}
  """

  @doc """
  Verify token
  """
  def verify(jwt) do
    FirebaseJwt.Verifier.verify(jwt)
  end

  @doc """
  Verify token and return payload only when it's valid
  """
  def verify!(jwt) do
    {:ok, payload} = FirebaseJwt.Verifier.verify(jwt)
    payload
  end
end

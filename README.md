# FirebaseJwt

This verifies Firebase `id_token` and fetch claims from it.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `firebase_jwt` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:firebase_jwt, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
{:ok, claims} = FirebaseJwt.verify(token)

# claims
{
  "aud": "ex-firebase-jwt",
  "auth_time": 1681029095,
  "exp": 1681032695,
  "firebase": {
    "identities": {
    },
    "sign_in_provider": "anonymous"
  },
  "iat": 1681029095,
  "iss": "https://example.com/ecpplus/ex-firebase-jwt",
  "provider_id": "anonymous",
  "sub": "pq8Lh98ElfZkLJzO2jDuOgHbk26G",
  "user_id": "pq8Lh98ElfZkLJzO2jDuOgHbk26G"
}
```

## For Firebase simulator

Firebase simulator makes none algorithm JWTs.

```elixir
config :firebase_jwt,
  simulator_mode: true
```

This gets you the claims without verifying JWT. (Don't use this for production).
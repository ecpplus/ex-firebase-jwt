defmodule FirebaseJwtTest do
  use ExUnit.Case

  def json_web_token_string() do
    "{\"aud\":\"ex-firebase-jwt\",\"auth_time\":1681029095,\"exp\":1681032695,\"firebase\":{\"identities\":{},\"sign_in_provider\":\"anonymous\"},\"iat\":1681029095,\"iss\":\"https://example.com/ecpplus/ex-firebase-jwt\",\"provider_id\":\"anonymous\",\"sub\":\"pq8Lh98ElfZkLJzO2jDuOgHbk26G\",\"user_id\":\"pq8Lh98ElfZkLJzO2jDuOgHbk26G\"}"
  end

  describe "FirebaseJwt.verity/1" do
    test "when simulator_mode=true returns claims" do
      :ok = Application.put_env(:firebase_jwt, :simulator_mode, true)

      claim = "{\"aud\":\"ex-firebase-jwt\",\"auth_time\":1681029095,\"exp\":1681032695,\"firebase\":{\"identities\":{},\"sign_in_provider\":\"anonymous\"},\"iat\":1681029095,\"iss\":\"https://example.com/ecpplus/ex-firebase-jwt\",\"provider_id\":\"anonymous\",\"sub\":\"pq8Lh98ElfZkLJzO2jDuOgHbk26G\",\"user_id\":\"pq8Lh98ElfZkLJzO2jDuOgHbk26G\"}" |> Base.encode64()
      token = "eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.#{claim}."

      {:ok, claims} = FirebaseJwt.verify(token)

      assert claims["sub"] == "pq8Lh98ElfZkLJzO2jDuOgHbk26G"
      assert claims["user_id"] == "pq8Lh98ElfZkLJzO2jDuOgHbk26G"
    end

    test "when simulator_mode=nil verity token and raise error" do
      :ok = Application.put_env(:firebase_jwt, :simulator_mode, nil)

      claim = "{\"aud\":\"ex-firebase-jwt\",\"auth_time\":1681029095,\"exp\":1681032695,\"firebase\":{\"identities\":{},\"sign_in_provider\":\"anonymous\"},\"iat\":1681029095,\"iss\":\"https://example.com/ecpplus/ex-firebase-jwt\",\"provider_id\":\"anonymous\",\"sub\":\"pq8Lh98ElfZkLJzO2jDuOgHbk26G\",\"user_id\":\"pq8Lh98ElfZkLJzO2jDuOgHbk26G\"}" |> Base.encode64()
      token = "eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.#{claim}."

      assert_raise MatchError, fn ->
        FirebaseJwt.verify(token)
      end
    end
  end
end

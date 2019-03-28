defmodule FirebaseJwtTest do
  use ExUnit.Case
  doctest FirebaseJwt

  test "greets the world" do
    assert FirebaseJwt.hello() == :world
  end
end

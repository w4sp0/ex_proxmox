defmodule PVE.TokenTest do
  use ExUnit.Case, async: true

  alias PVE.Token

  @secret "12345678-1234-1234-1234-123456789abc"


  # This is a simple test case to check the addition function
  describe "new/4" do
    test "builds a token from valid parts" do
      assert {:ok, token} = Token.new("root", "pam", "automation", @secret)

      assert %Token{
        user: "root",
        realm: "pam",
        token_id: "automation",
        secret: @secret
      } = token
    end

    test "accepts an uppercase secret" do
      assert {:ok, _} = Token.new("root", "pam", "automation", String.upcase(@secret))
    end

    test "rejects an empty user" do
      assert {:error, {:user, _}} = Token.new("", "pam", "automation", @secret)
    end

    test "rejects a non-string realm" do
      assert {:error, {:realm, _}} = Token.new("root", nil, "automation", @secret)
    end

    test "rejects token id which starts with a non-letter" do
      assert {:error, {:token_id, _}} = Token.new("root", "pam", "9lives", @secret)
    end

    test "rejects token id with illegal characters" do
      assert {:error, {:token_id, _}} = Token.new("root", "pam", "auto mation", @secret)
    end

    test "rejects a truncated secret" do
      assert {:error, {:secret, _}} = Token.new("root", "pam", "automation", "12345678-1234")
    end

    test "rejects only the first invalid field" do
      assert {:error, {:user, _}} = Token.new("", "pam", "auto mation", "12345678-1234")
    end
  end
end

# SPDX-FileCopyrightText: 2026 Radek Janik <cyberwassp@gmail.com>
#
# SPDX-License-Identifier: MIT

defmodule PVE.ClusterTest do
  use ExUnit.Case, async: true

  alias PVE.{Cluster, Token}

  @secret "12345678-1234-1234-1234-123456789abc"

  defp token do
    {:ok, token} = Token.new("root", "pam", "automation", @secret)
    token
  end

  # This is a simple test case to check the addition function
  describe "new/3" do
    test "applies defaults when no options are given" do
      assert {:ok, cluster} = Cluster.new("pve.example.com", token())

      assert %Cluster{
        host: "pve.example.com",
        port: 8006,
        scheme: :https,
        verify_tls: true
      } = cluster
    end

    test "keeps the token it was given" do
      given = token()
      assert {:ok, %Cluster{token: ^given}} = Cluster.new("pve.example.com", given)
    end

    test "accepts overrides for every option" do
      opts = [port: 443, scheme: :http, verify_tls: false]
      assert {:ok, cluster} = Cluster.new("pve.example.com", token(), opts)
      assert %Cluster{port: 443, scheme: :http, verify_tls: false} = cluster
    end

    test "rejects empty host" do
      assert {:error, {:host, _}} = Cluster.new("", token())
    end

    test "rejects a non-string host" do
      assert {:error, {:host, _}} = Cluster.new(nil, token())
    end

    test "rejects anything that is not a token" do
      assert {:error, {:token, _}} = Cluster.new("pve.example.com", %{user: "root"})
    end

    test "rejects a non-integer port" do
      assert {:error, {:port, _}} = Cluster.new("pve.example.com", token(), port: "8006")
    end

    test "rejects a port outsie 1..65535" do
      assert {:error, {:port, _}} = Cluster.new("pve.example.com", token(), port: 0)
      assert {:error, {:port, _}} = Cluster.new("pve.example.com", token(), port: 65536)
    end

    test "rejects unsupported scheme" do
      assert {:error, {:scheme, _}} = Cluster.new("pve.example.com", token(), scheme: :ftp)
    end

    test "rejects non-boolean verify_tls" do
      assert {:error, {:verify_tls, _}} = Cluster.new("pve.example.com", token(), verify_tls: :yes)
    end
  end
end

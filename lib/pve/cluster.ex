defmodule PVE.Cluster do
  @moduledoc """
    Connection details for proxmox cluster.
  """

  alias PVE.Token

  @enforce_keys [:host, :token]
  defstruct [:host, :token, :port, scheme: :https, verify_tls: true]
    @type t :: %__MODULE__{
      host: String.t(),
      token: Token.t(),
      port: 1..65_535,
      scheme: :http | :https,
      verify_tls: boolean()
    }

  @spec new(String.t(), Token.t(), keyword()) ::
    {:ok, t() | :error, {atom(), String.t()}}
  def new(host, token, opts \\ []) do
    port = Keyword.get(opts, :port, 8006)
    scheme = Keyword.get(opts, :scheme, :https)
    verify_tls = Keyword.get(opts, :verify_tls, true)
    with :ok <- validate_host(host),
         :ok <- validate_token(token),
         :ok <- validate_port(port),
         :ok <- validate_scheme(scheme),
         :ok <- validate_verify_tls(verify_tls) do
    {:ok,
    %__MODULE__{
      host: host,
      token: token,
      port: port,
      scheme: scheme,
      verify_tls: verify_tls
      }}
    end
  end

  @spec base_url(t()) :: String.t()
  def base_url(%__MODULE__{scheme: scheme, host: host, port: port}) do
    "#{scheme}://#{host}:#{port}/api2/json"
  end

  defp validate_host(host) when is_binary(host) and host != "", do: :ok
  defp validate_host(_host), do: {:error, {:host, "must not be empty string"}}

  defp validate_token(%Token{}), do: :ok
  defp validate_token(_token), do: {:error, {:token, "must be a PVE.Token struct"}}

  defp validate_port(port) when is_integer(port) and port in 1..65_535, do: :ok
  defp validate_port(_port), do: {:error, {:port, "must be an integer between 1 and 65535"}}

  defp validate_scheme(scheme) when scheme in [:http, :https], do: :ok
  defp validate_scheme(_scheme), do: {:error, {:scheme, "must be :http or :https"}}

  defp validate_verify_tls(verify_tls) when is_boolean(verify_tls), do: :ok
  defp validate_verify_tls(_verify_tls), do: {:error, {:verify_tls, "must be a boolean"}}
end

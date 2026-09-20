defmodule PVE.Token do
  @moduledoc """
    A Proxmox VE API token.
    Sent as: `Authorization: PVEAPIToken=user@realm!token_id=secret`
    """

  @enforce_keys [:user, :realm, :token_id, :secret]

  @derive {Inspect, except: [:secret]}
  defstruct [:user, :realm, :token_id, :secret]
    @type t :: %__MODULE__{
      user: String.t() | nil,
      realm: String.t() | nil,
      token_id: String.t() | nil,
      secret: String.t() | nil
    }

  @token_id ~r/^[A-Za-z][A-Za-z0-9._-]+$/
  @secret ~r/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i

  @spec new(String.t(), String.t(), String.t(), String.t()) ::
    {:ok, t() | :error, {atom(), String.t()}}
  def new(user, realm, token_id, secret) do
    with :ok <- present(:user, user),
         :ok <- present(:realm, realm),
         :ok <- format(:token_id, token_id, @token_id),
         :ok <- format(:secret, secret, @secret) do
    {:ok, %__MODULE__{user: user, realm: realm, token_id: token_id, secret: secret}}
    end
  end
# NOTE: claude --resume 74c0a875-b033-49f6-b78b-bcd05802c037
  defp present(_field, value) when is_binary(value) and value != "", do: :ok
  defp present(field, _value), do: {:error, {field, "must be non-empty-string"}}

  defp format(field, value, regex) when is_binary(value) do
    if Regex.match?(regex, value), do: :ok, else: {:error, {field, "has invalid format"}}
  end
  defp format(field, _value, _regex), do: {:error, {field, "must be a string"}}

  @spec to_header(t()) :: {String.t(), String.t()}
  def to_header(%__MODULE__{user: user, realm: realm, token_id: token_id, secret: secret}) do
    {"authorization", "PVEAPIToken=#{user}@#{realm}!#{token_id}=#{secret}"}
  end
end

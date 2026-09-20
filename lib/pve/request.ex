defmodule PVE.Request do

  @moduledoc """
    Builds a request from PVE.Cluster.
  """

  alias PVE.{Cluster, Token}

  @spec new(Cluster.t()) :: Req.Request.t()
  def new(%Cluster{} = cluster) do
    Req.new(
      base_url: Cluster.base_url(cluster),
      headers: [Token.to_header(cluster.token)],
      connect_options: [transport_opts: transport_opts(cluster)]
    )
  end

  defp transport_opts(%Cluster{verify_tls: true}), do: []
  defp transport_opts(%Cluster{verify_tls: false}), do: [verify: :verify_none]
end

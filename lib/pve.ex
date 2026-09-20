defmodule PVE do
  @moduledoc """
  Documentation for `PVE`.
  """

  alias PVE.{Cluster, Request}

  @spec version(Cluster.t()) :: {:ok, map()} | {:error, term()}
  def version(%Cluster{} = cluster) do
    cluster
    |> Request.new()
    |> Request.get(url: "/version")
    |> handle()
  end

  defp handle({:ok, %Req.Response{status: 200, body: %{"data" => data}}}), do: {:ok, data}
  defp handle({:ok, %Req.Response{status: status, body: body}}), do: {:error, {status, body}}
  defp handle(:error, exception), do: {:error, exception}

end

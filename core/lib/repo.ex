defmodule ProtocolZero.Repo do
  @moduledoc """
  The Sovereign Interface to SurrealDB.
  """
  require Logger

  @base_url "http://localhost:8000"
  @user "root"
  @pass "root"
  @ns "sovereign"
  @db "protocol_zero"

  def client do
    Req.new(
      base_url: @base_url,
      auth: {@user, @pass},
      headers: [
        {"Accept", "application/json"},
        {"NS", @ns},
        {"DB", @db}
      ]
    )
  end

  def sql(query) do
    Logger.debug("💾 SQL: #{query}")
    Req.post(client(), url: "/sql", body: query)
    |> case do
      {:ok, %{status: 200, body: body}} -> {:ok, body}
      {:ok, %{status: status, body: body}} -> {:error, {status, body}}
      {:error, reason} -> {:error, reason}
    end
  end

  def health do
    Req.get(client(), url: "/health")
    |> case do
      {:ok, %{status: 200}} -> :ok
      _ -> :error
    end
  end
end
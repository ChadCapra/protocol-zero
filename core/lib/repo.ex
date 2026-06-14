defmodule ProtocolZero.Repo do
  @moduledoc """
  The Sovereign Interface to PostgreSQL.
  """
  use Ecto.Repo,
    otp_app: :protocol_zero_core,
    adapter: Ecto.Adapters.Postgres
end

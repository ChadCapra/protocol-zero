defmodule ProtocolZero.Application do
  use Application

  def start(_type, _args) do
    children = [
      ProtocolZero.Repo,
      {Plug.Cowboy, scheme: :http, plug: Scaffold.Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: ProtocolZero.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

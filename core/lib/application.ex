defmodule ProtocolZero.Application do
  use Application

  def start(_type, _args) do
    children = [
      # Start the Plug.Cowboy web server on port 4000
      {Plug.Cowboy, scheme: :http, plug: Scaffold.Router, options: [port: 4000]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    opts = [strategy: :one_for_one, name: ProtocolZero.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
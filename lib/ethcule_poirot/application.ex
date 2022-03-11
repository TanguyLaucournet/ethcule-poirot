defmodule EthculePoirot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Neo4j.Supervisor, name: Neo4j.Supervisor},
      {EthculePoirot.DynamicSupervisor, []}
    ]

    Neuron.Config.set(url: Application.fetch_env!(:ethcule_poirot, :api_url))

    Neuron.Config.set(
      connection_opts: [
        recv_timeout: Application.fetch_env!(:ethcule_poirot, :api_timeout)
      ]
    )

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EthculePoirot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

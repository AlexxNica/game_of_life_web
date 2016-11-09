defmodule GameOfLifeWeb do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(GameOfLifeWeb.Endpoint, [])
      # Start your own worker by calling: GameOfLifeWeb.Worker.start_link(arg1, arg2, arg3)
      # worker(GameOfLifeWeb.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GameOfLifeWeb.Supervisor]
    context = Supervisor.start_link(children, opts)
    :ok = GenEvent.add_handler(GameOfLife.EventManager, GameOfLifeWeb.EventReceiver, [])
    spawn(fn -> GameOfLifeWeb.DummyBoard.run(100) end)
    context
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GameOfLifeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule RinhaBackendWeb.Router do
  use RinhaBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RinhaBackendWeb do
    pipe_through :api

    resources "/pessoas", PessoaController, only: [:create, :index, :show]
    get "/contagem-pessoas", PessoaController, :show_count
  end
end

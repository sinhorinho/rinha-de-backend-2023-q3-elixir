defmodule RinhaBackendWeb.PessoaController do
  alias RinhaBackend.Pessoas
  use RinhaBackendWeb, :controller

  def create(conn, params) do
    case Pessoas.criar(params) do
      {:ok, pessoa} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/pessoas/#{pessoa.id}")
        |> render(:show, pessoa: pessoa)

      {:error, %Ecto.Changeset{} = changeset} ->
        error_status_code =
          if cast_errors?(changeset) do
            :bad_request
          else
            :unprocessable_entity
          end

        conn
        |> put_status(error_status_code)
        |> put_view(json: RinhaBackendWeb.ErrorJSON)
        |> render("changeset.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Pessoas.consultar(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(json: RinhaBackendWeb.ErrorJSON)
        |> render("404.json")

      pessoa ->
        render(conn, :show, pessoa: pessoa)
    end
  end

  def show_count(conn, _params) do
    contagem = Pessoas.contagem_pessoas()

    text(conn, contagem)
  end

  def index(conn, %{"t" => termo}) do
    pessoas = Pessoas.listar(termo)

    render(conn, :index, pessoas: pessoas)
  end

  def index(conn, _) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: RinhaBackendWeb.ErrorJSON)
    |> render("400.json")
  end

  defp cast_errors?(%Ecto.Changeset{} = changeset) do
    Enum.any?(changeset.errors, fn {_key, descr} ->
      error_type =
        descr
        |> elem(1)
        |> Keyword.get(:validation)

      error_type == :cast
    end)
  end
end

defmodule RinhaBackend.Pessoas do
  @moduledoc """
  Contexto de pessoas, contem funcoes para criacao e manipulacao.
  """

  use Nebulex.Cache,
    otp_app: :rinha_backend,
    adapter: NebulexRedisAdapter

  use Nebulex.Caching

  import Ecto.Query

  alias RinhaBackend.{Pessoas.Pessoa, Repo}

  def criar(attrs) do
    attrs
    |> Pessoa.changeset()
    |> Repo.insert()
    |> case do
      {:ok, pessoa} ->
        __MODULE__.put(pessoa.id, pessoa, ttl: :timer.hours(1))
        {:ok, pessoa}

      error ->
        error
    end
  end

  @decorate cacheable(
              cache: __MODULE__,
              key: id,
              opts: [ttl: :timer.hours(1)]
            )
  def consultar(id) do
    Repo.get(Pessoa, id)
  end

  def listar(termo) do
    query =
      from(p in Pessoa,
        where: ilike(p.busca_trgm, ^"%#{termo}%"),
        limit: 50
      )

    Repo.all(query)
  end

  def contagem_pessoas do
    case Repo.one(from p in Pessoa, select: count(p.id)) do
      nil ->
        0

      contagem ->
        contagem
    end
  end
end

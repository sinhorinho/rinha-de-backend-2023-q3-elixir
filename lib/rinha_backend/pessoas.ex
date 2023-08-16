defmodule RinhaBackend.Pessoas do
  import Ecto.Query

  alias RinhaBackend.{Pessoas.Pessoa, Repo}

  def criar(attrs) do
    attrs
    |> Pessoa.changeset()
    |> Repo.insert()
  end

  def consultar(id) do
    Repo.get(Pessoa, id)
  end

  def listar(termo) do
    query =
      from p in Pessoa,
        where:
          ilike(p.apelido, ^"%#{termo}%") or ilike(p.nome, ^"%#{termo}%") or ^termo in p.stack

    Repo.all(query)
  end
end

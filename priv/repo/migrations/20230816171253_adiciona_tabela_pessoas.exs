defmodule RinhaBackend.Repo.Migrations.AdicionaTabelaPessoas do
  use Ecto.Migration

  def up do
    execute """
    CREATE TABLE public.pessoas (
      id uuid NOT NULL,
      apelido varchar(255) NOT NULL,
      nome varchar(255) NOT NULL,
      nascimento date NOT NULL,
      stack _varchar NULL,
      inserted_at timestamp(0) NOT NULL,
      updated_at timestamp(0) NOT NULL,
      busca_trgm text NULL GENERATED ALWAYS AS (lower(nome::text) || lower(apelido::text)) STORED
    );
    """

    execute """
    CREATE EXTENSION PG_TRGM WITH SCHEMA public;
    """

    execute """
    CREATE INDEX IF NOT EXISTS IDX_PESSOAS_BUSCA_TGRM ON pessoas USING GIST (BUSCA_TRGM GIST_TRGM_OPS);
    """

    create unique_index(:pessoas, [:apelido])
  end

  def down do
    execute("DROP TABLE pessoas")
  end
end

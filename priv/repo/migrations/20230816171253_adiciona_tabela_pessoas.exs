defmodule RinhaBackend.Repo.Migrations.AdicionaTabelaPessoas do
  use Ecto.Migration

  def up do
    execute """
        CREATE OR REPLACE FUNCTION public.calculate_busca_trgm(nome text, apelido text, stack text[]) RETURNS text AS $$
        BEGIN
          RETURN lower(nome) || lower(apelido) || COALESCE(array_to_string(stack, ''), '');
        END;
        $$ LANGUAGE plpgsql IMMUTABLE;
    """

    execute """
    CREATE TABLE public.pessoas (
      id uuid NOT NULL,
      apelido varchar(255) NOT NULL,
      nome varchar(255) NOT NULL,
      nascimento date NOT NULL,
      stack _varchar NULL,
      busca_trgm text GENERATED ALWAYS AS (public.calculate_busca_trgm(nome, apelido, stack)) STORED
    );
    """

    execute """
    CREATE EXTENSION PG_TRGM WITH SCHEMA public;
    """

    execute """
    CREATE INDEX IF NOT EXISTS IDX_PESSOAS_BUSCA_TGRM ON public.pessoas USING GIST (BUSCA_TRGM public.GIST_TRGM_OPS);
    """

    create unique_index(:pessoas, [:apelido])
  end

  def down do
    execute("DROP TABLE pessoas")
  end
end

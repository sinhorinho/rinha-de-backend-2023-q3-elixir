defmodule RinhaBackend.Repo.Migrations.AdicionaTabelaPessoas do
  use Ecto.Migration

  def change do
    create table(:pessoas, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :apelido, :string, null: false
      add :nome, :string, null: false
      add :nascimento, :date, null: false
      add :stack, {:array, :string}
      timestamps()
    end

    create unique_index(:pessoas, [:apelido])
  end
end

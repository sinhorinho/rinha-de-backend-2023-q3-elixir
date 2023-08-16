defmodule RinhaBackend.Pessoas.Pessoa do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "pessoas" do
    field :apelido, :string
    field :nome, :string
    field :nascimento, :date
    field :stack, {:array, :string}
    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, attrs) do
    model
    |> cast(attrs, [:apelido, :nome, :nascimento, :stack])
    |> validate_required([:apelido, :nome, :nascimento])
    |> validate_length(:apelido, max: 32)
    |> validate_length(:nome, max: 100)
    |> unique_constraint(:apelido)
  end
end

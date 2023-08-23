defmodule RinhaBackend.Pessoas.Pessoa do
  @moduledoc """
  Modulo que representa o schema de Pessoa
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "pessoas" do
    field :apelido, :string
    field :nome, :string
    field :nascimento, :date
    field :stack, {:array, :string}
  end

  def changeset(model \\ %__MODULE__{}, attrs) do
    model
    |> cast(attrs, [:apelido, :nome, :nascimento, :stack])
    |> validate_required([:apelido, :nome, :nascimento])
    |> validate_length(:apelido, max: 32)
    |> validate_length(:nome, max: 100)
    |> validate_array(:stack, 32)
    |> unique_constraint(:apelido)
  end

  defp validate_array(changeset, field, max_length) do
    case get_change(changeset, field) do
      nil ->
        changeset

      array ->
        errors =
          array
          |> Enum.filter(&(String.length(&1) > max_length))
          |> Enum.map(fn _element ->
            {field, "cada elemento deve ter no máximo #{max_length} caracteres"}
          end)

        if Enum.any?(errors) do
          add_error(
            changeset,
            field,
            "alguns elementos excedem o limite de #{max_length} caracteres"
          )
        else
          changeset
        end
    end
  end
end

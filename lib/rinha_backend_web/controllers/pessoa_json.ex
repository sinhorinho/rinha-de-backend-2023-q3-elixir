defmodule RinhaBackendWeb.PessoaJSON do
  def show(%{pessoa: pessoa}) do
    map_pessoa(pessoa)
  end

  def index(%{pessoas: pessoas}) do
    for(pessoa <- pessoas, do: map_pessoa(pessoa))
  end

  defp map_pessoa(pessoa) do
    %{
      id: pessoa.id,
      apelido: pessoa.apelido,
      nome: pessoa.nome,
      nascimento: pessoa.nascimento,
      stack: pessoa.stack
    }
  end
end

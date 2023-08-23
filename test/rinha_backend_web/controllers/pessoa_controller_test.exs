defmodule RinhaBackendWeb.PessoaControllerTest do
  use RinhaBackendWeb.ConnCase

  alias RinhaBackend.Pessoas

  @pessoa_params %{
    nome: "John Doe",
    apelido: "doe",
    nascimento: ~D[2001-01-01],
    stack: ["C#", "Ruby"]
  }

  describe "POST /pessoas" do
    test "with all parameters should create a person", %{conn: conn} do
      resp = post(conn, "/pessoas", @pessoa_params)

      assert resp.status == 201
    end

    test "with missing parameters returns 422 with an error", %{conn: conn} do
      params = %{
        nome: "John Doe",
        nascimento: ~D[2001-01-01],
        stack: ["C#", "Ruby"]
      }

      resp = post(conn, "/pessoas", params)

      assert resp.status == 422
    end

    test "with invalid stack should return 400", %{conn: conn} do
      params = %{
        nome: "John Doe",
        apelido: "doe",
        nascimento: ~D[2001-01-01],
        stack: "string"
      }

      resp = post(conn, "/pessoas", params)

      assert resp.status == 400
    end

    test "with some item in stack for greater than 32 it should return 422", %{conn: conn} do
      params = %{
        nome: "John Doe",
        apelido: "doe",
        nascimento: ~D[2001-01-01],
        stack: ["C#", "Ruby", String.duplicate("a", 33)]
      }

      resp = post(conn, "/pessoas", params)

      assert resp.status == 422
    end

    test "cast errors should return 400", %{conn: conn} do
      params = %{
        nome: 2,
        apelido: "doe",
        nascimento: ~D[2001-01-01]
      }

      resp = post(conn, "/pessoas", params)

      assert resp.status == 400
    end
  end

  describe "GET /pessoas/:id" do
    test "returns the person if it exists", %{conn: conn} do
      {:ok, person} = Pessoas.criar(@pessoa_params)

      resp = get(conn, "/pessoas/#{person.id}")

      assert resp.status == 200

      body = Jason.decode!(resp.resp_body)
      assert body["id"] == person.id
    end

    test "returns 404 if doesn't exist", %{conn: conn} do
      uuid = Ecto.UUID.generate()
      resp = get(conn, "/pessoas/#{uuid}")

      assert resp.status == 404
    end
  end

  describe "GET /pessoas/?t=:term" do
    test "term is mandatory", %{conn: conn} do
      resp = get(conn, "/pessoas/?q=test")

      assert resp.status == 400
    end

    test "lists the people by their name", %{conn: conn} do
      {:ok, _} = Pessoas.criar(@pessoa_params)

      {:ok, _} =
        @pessoa_params
        |> Map.put(:nome, "Jane Doe")
        |> Map.put(:apelido, "jdoe")
        |> Pessoas.criar()

      {:ok, _} =
        @pessoa_params
        |> Map.put(:nome, "Peter Parker")
        |> Map.put(:apelido, "spiderman")
        |> Pessoas.criar()

      resp = get(conn, "/pessoas/?t=doe")

      assert resp.status == 200

      body = Jason.decode!(resp.resp_body)
      assert length(body) == 2
    end

    test "lists the people by their stack", %{conn: conn} do
      {:ok, _} = Pessoas.criar(@pessoa_params)

      {:ok, _} =
        @pessoa_params
        |> Map.put(:nome, "Jane Doe")
        |> Map.put(:apelido, "jdoe")
        |> Map.put(:stack, ["Ruby", "Elixir"])
        |> Pessoas.criar()

      {:ok, _} =
        @pessoa_params
        |> Map.put(:nome, "Peter Parker")
        |> Map.put(:apelido, "spiderman")
        |> Map.put(:stack, ["Web"])
        |> Pessoas.criar()

      resp = get(conn, "/pessoas/?t=Ruby")

      assert resp.status == 200

      body = Jason.decode!(resp.resp_body)
      assert length(body) == 2
    end
  end
end

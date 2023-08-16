defmodule RinhaBackendWeb.ErrorJSON do
  def render("changeset.json", %{changeset: changeset}) do
    errors =
      Enum.map(changeset.errors, fn {field, detail} ->
        %{
          source: %{pointer: "/data/attributes/#{field}"},
          title: "Invalid Attribute",
          detail: render_detail(detail)
        }
      end)

    %{errors: errors}
  end

  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  defp render_detail({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", inspect(v))
    end)
  end

  defp render_detail(message) do
    message
  end
end

defmodule DailyLogWeb.LogLive do
  use DailyLogWeb, :live_view
  use Phoenix.HTML
  alias DailyLog.Logs

  @impl true
  def mount(%{"day" => day}, _session, socket) do
    day = Date.from_iso8601!(day)
    log = Logs.get_or_init_by_day(day)

    {:ok, assign(socket, log: log, log_changeset: log, errors: %{}, day: day)}
  end

  @impl true
  def handle_event("validate", %{"log" => log_params}, socket) do
    log_changeset =
      Logs.validate(
        socket.assigns.log,
        log_params |> Map.put("day", socket.assigns.day)
      )

    {:noreply,
     assign(socket, log_changeset: log_changeset, errors: translate_errors(log_changeset))}
  end

  @impl true
  def handle_event("save", _params, socket) do
    case socket.assigns.log_changeset |> Logs.insert_or_update() do
      {:ok, _} ->
        {:noreply, push_redirect(socket, to: Routes.live_path(socket, DailyLogWeb.CalendarLive))}

      {:error, log_changeset} ->
        {:noreply,
         assign(socket, log_changeset: log_changeset, errors: translate_errors(log_changeset))}
    end
  end

  defp translate_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {field, msg} -> {field, "#{field} #{Enum.join(msg, ", ")}"} end)
    |> Enum.into(%{})
  end
end

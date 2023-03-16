defmodule ExampleWeb.LiveExample3 do
  use ExampleWeb, :live_view

  def render(assigns) do
    ~H"""
    <LiveSvelte.render name="LogList" props={%{items: @items}} />
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)
    {:ok, assign(socket, :items, [])}
  end

  def handle_event("add_item", %{"name" => name}, socket) do
    {:noreply, assign(socket, :items, add_log(socket, name))}
  end

  def handle_info(:tick, socket) do
    datetime =
      DateTime.utc_now()
      |> DateTime.to_string()

    {:noreply, assign(socket, :items, add_log(socket, datetime))}
  end

  defp add_log(socket, body) do
    [%{id: System.unique_integer([:positive]), name: body} | socket.assigns.items]
  end
end
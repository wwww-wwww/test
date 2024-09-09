defmodule TestWeb.BuildTest do
  use TestWeb.ConnCase, async: true

  @outdir "out"

  def generate_html_for_route(conn, route_path) do
    IO.inspect(route_path)

    resp =
      get(conn, route_path)
      |> html_response(200)
      |> String.split(~r/\n/, trim: true)
      |> Enum.join("\n")

    priv_static_path = Path.join(@outdir, route_path)

    assert File.mkdir_p(priv_static_path) == :ok

    {:ok, file} =
      priv_static_path
      |> Path.join("index.html")
      |> File.open([:write])

    assert IO.binwrite(file, resp) == :ok
    File.close(file)
  end

  @routes [
    "/",
  ]

  test "GET /", %{conn: conn} do
    @routes
    |> Enum.each(&generate_html_for_route(conn, &1))
  end
end

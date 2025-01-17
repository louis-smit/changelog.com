defmodule ChangelogWeb.RobotsTest do
  use ChangelogWeb.ConnCase

  alias ChangelogWeb.Plug

  def build_conn_with_host_and_path(host, path) do
    build_conn(:get, path) |> put_req_header("host", host)
  end

  test "response for changelog.com" do
    conn =
      build_conn_with_host_and_path("changelog.com", "/robots.txt")
      |> Plug.Robots.call([])

    assert String.contains?(conn.resp_body, "sitemap")
    assert conn.halted
  end

  test "response for cdn.changelog.com" do
    conn =
      build_conn_with_host_and_path("cdn.changelog.com", "/robots.txt")
      |> Plug.Robots.call([])

    assert String.contains?(conn.resp_body, "allow: /images/")
    assert conn.halted
  end

  test "response for 21.changelog.com" do
    conn =
      build_conn_with_host_and_path("21.changelog.com", "/robots.txt")
      |> Plug.Robots.call([])

    assert String.contains?(conn.resp_body, "disallow: /")
    assert conn.halted
  end

  test "no-op for other paths" do
    conn =
      build_conn_with_host_and_path("changelog.com", "/roboooooots.txt")
      |> Plug.Robots.call([])

    assert conn.resp_body == nil
    refute conn.halted
  end
end

# SPDX-FileCopyrightText: 2026 Radek Janik <cyberwassp@gmail.com>
#
# SPDX-License-Identifier: MIT

defmodule PVE.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/w4sp0/ex_proxmox"

  def project do
    [
      app: :pve,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      name: "PVE",
      description: "Proxmox VE API client for Elixir",
      source_url: @source_url,
      homepage_url: @source_url,
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.5"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Radek Janik"],
      files: [
        "lib",
        "mix.exs",
        "README.md",
        "CHANGELOG.md",
        "LICENSES",
        "REUSE.toml"
      ],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => "#{@source_url}/blob/main/CHANGELOG.md"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md", "CHANGELOG.md", "docs/RELEASE.md"]
    ]
  end
end

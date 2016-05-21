defmodule Datastructures.Mixfile do
  use Mix.Project

  def project do
    [ app: :datastructures,
      version: "0.1.1",
      deps: deps,
      package: package,
      description: "Elixir protocols and implementations for various data structures." ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [ { :ex_doc, "~> 0.11", only: [:dev] } ]
  end

  defp package do
    [ maintainers: ["meh"],
      licenses: ["WTFPL"],
      links: %{"GitHub" => "https://github.com/meh/elixir-datastructures"} ]
  end
end

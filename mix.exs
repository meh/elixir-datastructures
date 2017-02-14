defmodule Datastructures.Mixfile do
  use Mix.Project

  def project do
    [ app: :datastructures,
      version: "0.2.6",
      deps: deps(),
      package: package(),
      description: "Elixir protocols and implementations for various data structures." ]
  end

  def application do
    []
  end

  defp deps do
    [ { :ex_doc, "~> 0.14", only: [:dev] } ]
  end

  defp package do
    [ maintainers: ["meh"],
      licenses: ["WTFPL"],
      links: %{"GitHub" => "https://github.com/meh/elixir-datastructures"} ]
  end
end

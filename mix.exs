defmodule Datastructures.Mixfile do
  use Mix.Project

  def project do
    [ app: :datastructures,
      version: "0.0.1",
      elixir: "~> 0.9.4 or ~> 0.10.0 or ~> 0.11.0 or ~> 0.12.0",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    []
  end
end

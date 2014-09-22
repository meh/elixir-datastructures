#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Empty do
  defexception message: "the data is empty"
end

defmodule Data.OutOfBounds do
  defexception message: "out of bounds"
end

defmodule Data.Missing do
  defexception message: nil

  def exception(key: key) when key != nil do
    "key missing: #{inspect key}"
  end

  def exception(what: what) when what != nil do
    "#{inspect what} is missing"
  end
end

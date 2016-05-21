#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Error do
  defmodule Empty do
    defexception message: "the data is empty"
  end

  defmodule OutOfBounds do
    defexception message: "out of bounds"
  end

  defmodule Missing do
    defexception key: nil, what: nil

    def message(%__MODULE__{key: key}) when key != nil do
      "key missing: #{inspect key}"
    end

    def message(%__MODULE__{what: what}) when what != nil do
      "#{inspect what} is missing"
    end
  end
end

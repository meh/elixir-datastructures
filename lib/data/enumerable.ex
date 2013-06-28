#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Enumerable do
  defmacro __using__(_opts) do
    quote do
      defdelegate reduce(self, acc, fun), to: Data.Reducible
      defdelegate member?(self, value), to: Data, as: :contains?
      defdelegate count(self), to: Data, as: :count
    end
  end
end

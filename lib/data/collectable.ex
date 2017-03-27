#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Collectable do
  defmacro __using__(_opts) do
    quote do
      def into(original) do
        { original, fn
            result, { :cont, value } ->
              Data.into(result, value)

            result, :done ->
              result

            _, :halt ->
              :ok
        end }
      end
    end
  end
end

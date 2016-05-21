#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Stack do
  alias Data.Error, as: E
  alias Data.Protocol.Stack, as: S

  defdelegate push(self, value), to: S

  def pop(self, default \\ nil) do
    case S.pop(self) do
      { :empty, queue } ->
        { default, queue }

      { { :value, value }, queue } ->
        { value, queue }
    end
  end

  def pop!(self) do
    case S.pop(self) do
      { :empty, _ } ->
        raise E.Empty

      { { :value, value }, queue } ->
        { value, queue }
    end
  end
end

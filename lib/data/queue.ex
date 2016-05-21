#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Queue do
  alias Data.Error, as: E
  alias Data.Protocol.Queue, as: Q

  defdelegate enq(self, value), to: Q

  def deq(self, default \\ nil) do
    case Q.deq(self) do
      { :empty, queue } ->
        { default, queue }

      { { :value, value }, queue } ->
        { value, queue }
    end
  end

  def deq!(self) do
    case Q.deq(self) do
      { :empty, _ } ->
        raise E.Empty

      { { :value, value }, queue } ->
        { value, queue }
    end
  end
end

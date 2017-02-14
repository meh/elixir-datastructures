#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

alias Data.Protocol.Reduce, as: Protocol

defprotocol Protocol do
  @spec reduce(t, any, (any, any -> any)) :: any
  def reduce(self, acc, fun)
end

defimpl Protocol, for: List do
  defdelegate reduce(list, acc, fun), to: List, as: :foldl
end

defimpl Protocol, for: Map do
  defdelegate reduce(self, acc, fun), to: Enum
end

defimpl Protocol, for: MapSet do
  defdelegate reduce(self, acc, fun), to: Enum
end

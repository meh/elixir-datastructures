#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Protocol.Reduce do
  @spec reduce(t, any, (any, any -> any)) :: any
  def reduce(self, acc, fun)
end

defimpl Data.Protocol.Reduce, for: List do
  defdelegate reduce(list, acc, fun), to: List, as: :foldl
end

defimpl Data.Protocol.Reduce, for: Map do
  defdelegate reduce(self, acc, fun), to: Map
end

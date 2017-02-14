#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

alias Data.Protocol.Count, as: Protocol

defprotocol Protocol do
  @spec count(t) :: non_neg_integer
  def count(self)
end

defimpl Protocol, for: List do
  def count(self) do
    length(self)
  end
end

defimpl Protocol, for: Map do
  defdelegate count(self), to: Map, as: :size
end

defimpl Protocol, for: MapSet do
  defdelegate count(self), to: MapSet, as: :size
end

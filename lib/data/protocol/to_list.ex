#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Protocol.ToList do
  @spec to_list(t) :: list
  def to_list(self)
end

defimpl Data.Protocol.ToList, for: List do
  def to_list(list) do
    list
  end
end

defimpl Data.Protocol.ToList, for: Map do
  defdelegate to_list(self), to: Map
end

defimpl Data.Protocol.ToList, for: MapSet do
  defdelegate to_list(self), to: MapSet
end

defimpl Data.Protocol.ToList, for: HashSet do
  defdelegate to_list(self), to: HashSet
end

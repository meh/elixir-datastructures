#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

alias Data.Protocol.Empty, as: Protocol

defprotocol Protocol do
  @spec empty?(t) :: boolean
  def empty?(self)

  @spec clear(t) :: t
  def clear(self)
end

defimpl Protocol, for: List do
  def empty?([]) do
    true
  end

  def empty?(_) do
    false
  end

  def clear(_) do
    []
  end
end

defimpl Protocol, for: Map do
  def empty?(self) do
    Map.size(self) == 0
  end

  def clear(_) do
    Map.new()
  end
end

defimpl Protocol, for: MapSet do
  def empty?(self) do
    MapSet.size(self) == 0
  end

  def clear(_) do
    MapSet.new()
  end
end

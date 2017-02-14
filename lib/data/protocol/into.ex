#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

alias Data.Protocol.Into, as: Protocol

defprotocol Protocol do
  @spec into(t, any) :: t
  def into(self, value)
end

defimpl Protocol, for: List do
  def into(self, value) do
    self ++ [value]
  end
end

defimpl Protocol, for: Map do
  def into(self, { key, value }) do
    self |> Map.put(key, value)
  end
end

defimpl Protocol, for: MapSet do
  def into(self, value) do
    self |> MapSet.put(value)
  end
end

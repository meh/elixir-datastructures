#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Protocol.Reverse do
  @spec reverse(t) :: t
  def reverse(self)
end

defimpl Data.Protocol.Reverse, for: List do
  def reverse(list) do
    Enum.reverse(list)
  end
end

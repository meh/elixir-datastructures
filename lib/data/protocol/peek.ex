#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Protocol.Peek do
  @spec peek(t) :: { :value, any } | :empty
  def peek(self)
end

defimpl Data.Protocol.Peek, for: List do
  def peek([]) do
    :empty
  end

  def peek([head | _]) do
    { :value, head }
  end
end

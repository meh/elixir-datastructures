#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

alias Data.Protocol.Peek, as: Protocol

defprotocol Protocol do
  @spec peek(t) :: { :value, any } | :empty
  def peek(self)
end

defimpl Protocol, for: List do
  def peek([]) do
    :empty
  end

  def peek([head | _]) do
    { :value, head }
  end
end

#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Peekable do
  @spec peek(t)      :: any
  @spec peek(t, any) :: any
  def peek(self, default \\ nil)

  @spec peek!(t) :: any | no_return
  def peek!(self)
end

defimpl Data.Peekable, for: List do
  def peek([], default) do
    default
  end

  def peek([head | _], _) do
    head
  end

  def peek!([]) do
    raise Data.Empty
  end

  def peek!([head | _]) do
    head
  end
end

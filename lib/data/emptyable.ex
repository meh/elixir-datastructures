#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Emptyable do
  @spec empty?(t) :: boolean
  def empty?(self)

  @spec clear(t) :: t
  def clear(self)
end

defimpl Data.Emptyable, for: List do
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

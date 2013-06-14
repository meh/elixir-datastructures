#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Reducible do
  @spec reduce(t, any, ((any, any) -> any)) :: any
  def reduce(self, acc, fun)
end

defimpl Data.Reducible, for: List do
  defdelegate reduce(list, acc, fun), to: List, as: :foldl
end

#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defimpl Data.Dictionary, for: Map do
  defdelegate fetch(self, key), to: Map
  defdelegate put(self, key, value), to: Map
  defdelegate delete(self, key), to: Map
  defdelegate keys(self), to: Map
  defdelegate values(self), to: Map
end

defimpl Data.Emptyable, for: Map do
  def empty?(self) do
    Map.size(self) == 0
  end

  defdelegate clear(self), to: Map, as: :empty
end

defimpl Data.Counted, for: Map do
  defdelegate count(self), to: Map, as: :size
end

defimpl Data.Reducible, for: Map do
  defdelegate reduce(self, acc, fun), to: Map
end

defimpl Data.Listable, for: Map do
  defdelegate to_list(self), to: Map
end

defimpl Data.Contains, for: Map do
  defdelegate contains?(self, key), to: Map, as: :has_key?
end

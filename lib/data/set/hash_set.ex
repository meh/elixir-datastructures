#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defimpl Data.Set, for: HashSet do
  defdelegate add(self, value), to: HashSet, as: :put
  defdelegate delete(self, value), to: HashSet
  defdelegate union(self, other), to: HashSet
  defdelegate intersection(self, other), to: HashSet
  defdelegate difference(self, other), to: HashSet
  defdelegate subset?(self, other), to: HashSet
  defdelegate disjoint?(self, other), to: HashSet
end

defimpl Data.Emptyable, for: HashSet do
  def empty?(self) do
    HashSet.size(self) == 0
  end

  defdelegate clear(self), to: HashSet, as: :empty
end

defimpl Data.Counted, for: HashSet do
  defdelegate count(self), to: HashSet, as: :size
end

defimpl Data.Reducible, for: HashSet do
  defdelegate reduce(self, acc, fun), to: HashSet
end

defimpl Data.Listable, for: HashSet do
  defdelegate to_list(self), to: HashSet
end

defimpl Data.Contains, for: HashSet do
  defdelegate contains?(self, key), to: HashSet, as: :member?
end

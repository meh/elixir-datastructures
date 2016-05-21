#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

alias Data.Protocol, as: P

defimpl P.Set, for: HashSet do
  defdelegate add(self, value), to: HashSet, as: :put
  defdelegate delete(self, value), to: HashSet
  defdelegate union(self, other), to: HashSet
  defdelegate intersection(self, other), to: HashSet
  defdelegate difference(self, other), to: HashSet
  defdelegate subset?(self, other), to: HashSet
  defdelegate disjoint?(self, other), to: HashSet
end

defimpl P.Empty, for: HashSet do
  def empty?(self) do
    HashSet.size(self) == 0
  end

  defdelegate clear(self), to: HashSet, as: :empty
end

defimpl P.Count, for: HashSet do
  defdelegate count(self), to: HashSet, as: :size
end

defimpl P.Reduce, for: HashSet do
  defdelegate reduce(self, acc, fun), to: HashSet
end

defimpl P.ToList, for: HashSet do
  defdelegate to_list(self), to: HashSet
end

defimpl P.Contains, for: HashSet do
  defdelegate contains?(self, key), to: HashSet, as: :member?
end

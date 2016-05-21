#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

alias Data.Protocol, as: P

defimpl P.Set, for: MapSet do
  defdelegate add(self, value), to: MapSet, as: :put
  defdelegate delete(self, value), to: MapSet
  defdelegate union(self, other), to: MapSet
  defdelegate intersection(self, other), to: MapSet
  defdelegate difference(self, other), to: MapSet
  defdelegate subset?(self, other), to: MapSet
  defdelegate disjoint?(self, other), to: MapSet
end

defimpl P.Empty, for: MapSet do
  def empty?(self) do
    MapSet.size(self) == 0
  end

  defdelegate clear(self), to: MapSet, as: :empty
end

defimpl P.Count, for: MapSet do
  defdelegate count(self), to: MapSet, as: :size
end

defimpl P.Reduce, for: MapSet do
  defdelegate reduce(self, acc, fun), to: MapSet
end

defimpl P.ToList, for: MapSet do
  defdelegate to_list(self), to: MapSet
end

defimpl P.Contains, for: MapSet do
  defdelegate contains?(self, key), to: MapSet, as: :member?
end

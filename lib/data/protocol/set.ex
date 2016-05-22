#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

alias Data.Protocol.Set, as: Protocol

defprotocol Protocol do
  @type v :: any

  @spec add(t, v) :: t
  def add(self, value)

  @spec delete(t, v) :: t
  def delete(self, value)

  @spec union(t, t) :: t
  def union(self, other)

  @spec intersection(t, t) :: t
  def intersection(self, other)

  @spec difference(t, t) :: t
  def difference(self, other)

  @spec subset?(t, t) :: boolean
  def subset?(self, other)

  @spec disjoint?(t, t) :: boolean
  def disjoint?(self, other)
end

defimpl Protocol, for: List do
  def new do
    []
  end

  def new(enum) do
    Data.list(enum) |> :ordsets.from_list
  end

  def valid?(self) when is_list(self) do
    :ordsets.is_set(self)
  end

  def valid?(_) do
    false
  end

  def add(self, element) do
    :ordsets.add_element(element, self)
  end

  def delete(self, element) do
    :ordsets.del_element(element, self)
  end

  def union(self, other) do
    :ordsets.union(self, new(other))
  end

  def intersection(self, other) do
    :ordsets.intersection(self, new(other))
  end

  def difference(self, other) do
    :ordsets.difference(self, new(other))
  end

  def subset?(self, other) do
    :ordsets.is_subset(new(other), self)
  end

  def disjoint?(self, other) do
    :ordsets.is_disjoint(new(other), self)
  end
end

defimpl Protocol, for: MapSet do
  defdelegate add(self, value), to: MapSet, as: :put
  defdelegate delete(self, value), to: MapSet
  defdelegate union(self, other), to: MapSet
  defdelegate intersection(self, other), to: MapSet
  defdelegate difference(self, other), to: MapSet
  defdelegate subset?(self, other), to: MapSet
  defdelegate disjoint?(self, other), to: MapSet
end

defimpl Protocol, for: HashSet do
  defdelegate add(self, value), to: HashSet, as: :put
  defdelegate delete(self, value), to: HashSet
  defdelegate union(self, other), to: HashSet
  defdelegate intersection(self, other), to: HashSet
  defdelegate difference(self, other), to: HashSet
  defdelegate subset?(self, other), to: HashSet
  defdelegate disjoint?(self, other), to: HashSet
end

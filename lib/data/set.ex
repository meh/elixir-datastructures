#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Set do
  @type v :: any

  @spec add(t, v) :: t
  def add(self, value)

  @spec delete(t, v) :: t
  def delete(selv, value)

  @spec union(t, t) :: t
  def union(self, other)

  @spec intersection(t, t) :: t
  def intersection(self, other)

  @spec subset?(t, t) :: boolean
  def subset?(self, other)

  @spec disjoint?(t, t) :: boolean
  def disjoint?(self, other)
end

defimpl Data.Set, for: List do
  def new do
    :ordsets.new
  end

  def new(enum) do
    Data.to_list(enum) |> :ordsets.from_list
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
    :ordsets.union(self, L.new(other))
  end

  def intersection(self, other) do
    :ordsets.intersection(self, L.new(other))
  end

  def subset?(self, other) do
    :ordsets.is_subset(L.new(other), self)
  end

  def disjoint?(self, other) do
    :ordsets.is_disjoint(L.new(other), self)
  end
end

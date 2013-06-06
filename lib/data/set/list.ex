#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Set.List do
  def new do
    :ordsets.new
  end

  def new(enum) do
    Enum.to_list(enum) |> :ordsets.from_list
  end
end

defimpl Set, for: List do
  alias Data.Set.List, as: L

  def member?(self, element) do
    :ordsets.is_element(element, self)
  end

  def empty?([]), do: true
  def empty?(_), do: false

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

  def size(self) do
    :ordsets.size(self)
  end

  def reduce(self, acc, fun) do
    List.foldl(self, acc, fun)
  end

  def to_list(self) do
    :ordsets.to_list(self)
  end

  ## Specific functions

  def valid?(self) when is_list(self) do
    :ordsets.is_set(self)
  end

  def valid?(_) do
    false
  end
end

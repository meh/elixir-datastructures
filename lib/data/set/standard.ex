#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Set.Standard do
  defrecordp :wrap, set: nil

  def new do
    wrap(set: :sets.new)
  end

  def new(enum_or_set) do
    if :sets.is_set(enum_or_set) do
      wrap(set: enum_or_set)
    else
      wrap(set: Data.to_list(enum_or_set) |> :sets.from_list)
    end
  end

  def member?(wrap(set: self), element) do
    :sets.is_element(element, self)
  end

  def empty?(wrap(set: self)) do
    :sets.size(self) == 0
  end

  def clear(_) do
    wrap(set: :sets.new)
  end

  def add(wrap(set: self), element) do
    wrap(set: :sets.add_element(element, self))
  end

  def delete(wrap(set: self), element) do
    wrap(set: :sets.del_element(element, self))
  end

  def union(wrap(set: self), wrap(set: other)) do
    wrap(set: :sets.union(self, other))
  end

  def union(wrap(set: self), other) do
    wrap(set: :sets.union(self, Data.to_list(other) |> :sets.from_list))
  end

  def intersection(wrap(set: self), wrap(set: other)) do
    wrap(set: :sets.intersection(self, other))
  end

  def intersection(wrap(set: self), other) do
    wrap(set: :sets.intersection(self, Data.to_list(other) |> :sets.from_list))
  end

  def subset?(wrap(set: self), wrap(set: other)) do
    :sets.is_subset(other, self)
  end

  def subset?(wrap(set: self), other) do
    :sets.is_subset(Data.to_list(other) |> :sets.from_list, self)
  end

  def disjoint?(wrap(set: self), wrap(set: other)) do
    :sets.is_disjoint(other, self)
  end

  def disjoint?(wrap(set: self), other) do
    :sets.is_disjoint(Data.to_list(other) |> :sets.from_list, self)
  end

  def size(wrap(set: self)) do
    :sets.size(self)
  end

  def reduce(wrap(set: self), acc, fun) do
    :sets.fold(fun, acc, self)
  end

  def to_list(wrap(set: self)) do
    Data.Set.List.new(:sets.to_list(self))
  end

  ## Specific functions

  def filter(wrap(set: self), pred) do
    wrap(set: :sets.filter(pred, self))
  end
end

defimpl Data.Set, for: Data.Set.Standard do
  defdelegate add(self, value), to: Data.Set.Standard
  defdelegate delete(self, value), to: Data.Set.Standard
  defdelegate union(self, other), to: Data.Set.Standard
  defdelegate intersection(self, other), to: Data.Set.Standard
  defdelegate subset?(self, other), to: Data.Set.Standard
  defdelegate disjoint?(self, other), to: Data.Set.Standard
end

defimpl Data.Counted, for: Data.Set.Standard do
  defdelegate count(self), to: Data.Set.Standard
end

defimpl Data.Foldable, for: Data.Set.Standard do
  defdelegate foldl(self, acc, fun), to: Data.Set.Standard, as: :reduce
  defdelegate foldr(self, acc, fun), to: Data.Set.Standard, as: :reduce
end

defimpl Data.Listable, for: Data.Set.Standard do
  defdelegate to_list(self), to: Data.Set.Standard
end

defimpl Data.Emptyable, for: Data.Set.Standard do
  defdelegate empty?(self), to: Data.Set.Standard
  defdelegate clear(self), to: Data.Set.Standard
end

defimpl Data.Contains, for: Data.Set.Standard do
  defdelegate contains?(self, key), to: Data.Set.Standard, as: :member?
end

defimpl Enumerable, for: Data.Set.Standard do
  defdelegate reduce(self, acc, fun), to: Data.Set.Standard
  defdelegate count(self), to: Data.Set.Standard, as: :size
  defdelegate member?(self, value), to: Data.Set.Standard
end

defimpl Binary.Inspect, for: Data.Set.Standard do
  def inspect(set, opts) do
    "#Set<" <> Kernel.inspect(Data.Set.Standard.to_list(set), opts) <> ">"
  end
end

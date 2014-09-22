#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

require Record

defmodule Data.Set.BalancedTree do
  @opaque t :: record
  @type   v :: any

  Record.defrecordp :wrap, __MODULE__, set: nil

  def new do
    wrap(set: :gb_sets.new)
  end

  def new(enum_or_set) do
    if :gb_sets.is_set(enum_or_set) do
      wrap(set: enum_or_set)
    else
      wrap(set: Data.to_list(enum_or_set) |> :gb_sets.from_list)
    end
  end

  def member?(wrap(set: self), element) do
    :gb_sets.is_element(element, self)
  end

  def empty?(wrap(set: self)) do
    :gb_sets.is_empty(self)
  end

  def clear(_) do
    wrap(set: :gb_sets.new)
  end

  def add(wrap(set: self), element) do
    wrap(set: :gb_sets.add_element(element, self))
  end

  def delete(wrap(set: self), element) do
    wrap(set: :gb_sets.del_element(element, self))
  end

  def union(wrap(set: self), wrap(set: other)) do
    wrap(set: :gb_sets.union(self, other))
  end

  def union(wrap(set: self), other) do
    wrap(set: :gb_sets.union(self, Data.to_list(other) |> :gb_sets.from_list))
  end

  def intersection(wrap(set: self), wrap(set: other)) do
    wrap(set: :gb_sets.intersection(self, other))
  end

  def intersection(wrap(set: self), other) do
    wrap(set: :gb_sets.intersection(self, Data.to_list(other) |> :gb_sets.from_list))
  end

  def difference(wrap(set: self), wrap(set: other)) do
    wrap(set: :gb_sets.subtract(self, other))
  end

  def difference(wrap(set: self), other) do
    wrap(set: :gb_sets.subtract(self, Data.to_list(other) |> :gb_sets.from_list))
  end

  def subset?(wrap(set: self), wrap(set: other)) do
    :gb_sets.is_subset(other, self)
  end

  def subset?(wrap(set: self), other) do
    :gb_sets.is_subset(Data.to_list(other) |> :gb_sets.from_list, self)
  end

  def disjoint?(wrap(set: self), wrap(set: other)) do
    :gb_sets.is_disjoint(other, self)
  end

  def disjoint?(wrap(set: self), other) do
    :gb_sets.is_disjoint(Data.to_list(other) |> :gb_sets.from_list, self)
  end

  def size(wrap(set: self)) do
    :gb_sets.size(self)
  end

  def reduce(wrap(set: self), acc, fun) do
    :gb_sets.fold(fun, acc, self)
  end

  def to_list(wrap(set: self)) do
    Data.Set.List.new(:gb_sets.to_list(self))
  end

  ## Specific functions

  def balance(wrap(set: self)) do
    wrap(set: :gb_sets.balance(self))
  end

  def filter(wrap(set: self), pred) do
    :gb_sets.filter(pred, self)
  end
end

defimpl Data.Set, for: Data.Set.BalancedTree do
  defdelegate add(self, value), to: Data.Set.BalancedTree
  defdelegate delete(self, value), to: Data.Set.BalancedTree
  defdelegate union(self, other), to: Data.Set.BalancedTree
  defdelegate intersection(self, other), to: Data.Set.BalancedTree
  defdelegate difference(self, other), to: Data.Set.BalancedTree
  defdelegate subset?(self, other), to: Data.Set.BalancedTree
  defdelegate disjoint?(self, other), to: Data.Set.BalancedTree
end

defimpl Data.Counted, for: Data.Set.BalancedTree do
  defdelegate count(self), to: Data.Set.BalancedTree
end

defimpl Data.Reducible, for: Data.Set.BalancedTree do
  defdelegate reduce(self, acc, fun), to: Data.Set.BalancedTree
end

defimpl Data.Listable, for: Data.Set.BalancedTree do
  defdelegate to_list(self), to: Data.Set.BalancedTree
end

defimpl Data.Emptyable, for: Data.Set.BalancedTree do
  defdelegate empty?(self), to: Data.Set.BalancedTree
  defdelegate clear(self), to: Data.Set.BalancedTree
end

defimpl Data.Contains, for: Data.Set.BalancedTree do
  defdelegate contains?(self, value), to: Data.Set.BalancedTree, as: :member?
end

defimpl Data.Sequence, for: Data.Set.BalancedTree do
  def first(self) do
    Data.Set.BalancedTree.reduce(self, nil, fn(x, _) -> throw { :first, x } end)

    nil
  catch
    { :first, x } ->
      x
  end

  def next(self) do
    case Data.Set.BalancedTree.to_list(self) do
      [] ->
        nil

      [_] ->
        nil

      [_ | tail] ->
        tail
    end
  end
end

defimpl Enumerable, for: Data.Set.BalancedTree do
  use Data.Enumerable
end

defimpl Inspect, for: Data.Set.BalancedTree do
  import Inspect.Algebra

  def inspect(set, opts) do
    concat ["#Set<", Kernel.inspect(Data.Set.BalancedTree.to_list(set), opts), ">"]
  end
end

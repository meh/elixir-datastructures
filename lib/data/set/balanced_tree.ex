#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Set.BalancedTree do
  defstruct [:set]

  def new do
    %__MODULE__{set: :gb_sets.new}
  end

  def new(enum_or_set) do
    if :gb_sets.is_set(enum_or_set) do
      %__MODULE__{set: enum_or_set}
    else
      %__MODULE__{set: Data.to_list(enum_or_set) |> :gb_sets.from_list}
    end
  end

  def member?(%__MODULE__{set: self}, element) do
    :gb_sets.is_element(element, self)
  end

  def empty?(%__MODULE__{set: self}) do
    :gb_sets.is_empty(self)
  end

  def clear(_) do
    %__MODULE__{set: :gb_sets.new}
  end

  def add(%__MODULE__{set: self}, element) do
    %__MODULE__{set: :gb_sets.add_element(element, self)}
  end

  def delete(%__MODULE__{set: self}, element) do
    %__MODULE__{set: :gb_sets.del_element(element, self)}
  end

  def union(%__MODULE__{set: self}, %__MODULE__{set: other}) do
    %__MODULE__{set: :gb_sets.union(self, other)}
  end

  def union(%__MODULE__{set: self}, other) do
    %__MODULE__{set: :gb_sets.union(self, Data.to_list(other) |> :gb_sets.from_list)}
  end

  def intersection(%__MODULE__{set: self}, %__MODULE__{set: other}) do
    %__MODULE__{set: :gb_sets.intersection(self, other)}
  end

  def intersection(%__MODULE__{set: self}, other) do
    %__MODULE__{set: :gb_sets.intersection(self, Data.to_list(other) |> :gb_sets.from_list)}
  end

  def difference(%__MODULE__{set: self}, %__MODULE__{set: other}) do
    %__MODULE__{set: :gb_sets.subtract(self, other)}
  end

  def difference(%__MODULE__{set: self}, other) do
    %__MODULE__{set: :gb_sets.subtract(self, Data.to_list(other) |> :gb_sets.from_list)}
  end

  def subset?(%__MODULE__{set: self}, %__MODULE__{set: other}) do
    :gb_sets.is_subset(other, self)
  end

  def subset?(%__MODULE__{set: self}, other) do
    :gb_sets.is_subset(Data.to_list(other) |> :gb_sets.from_list, self)
  end

  def disjoint?(%__MODULE__{set: self}, %__MODULE__{set: other}) do
    :gb_sets.is_disjoint(other, self)
  end

  def disjoint?(%__MODULE__{set: self}, other) do
    :gb_sets.is_disjoint(Data.to_list(other) |> :gb_sets.from_list, self)
  end

  def size(%__MODULE__{set: self}) do
    :gb_sets.size(self)
  end

  def reduce(%__MODULE__{set: self}, acc, fun) do
    :gb_sets.fold(fun, acc, self)
  end

  def to_list(%__MODULE__{set: self}) do
    Data.Set.List.new(:gb_sets.to_list(self))
  end

  ## Specific functions

  def balance(%__MODULE__{set: self}) do
    %__MODULE__{set: :gb_sets.balance(self)}
  end

  def filter(%__MODULE__{set: self}, pred) do
    :gb_sets.filter(pred, self)
  end

  alias Data.Protocol, as: P

  defimpl P.Set do
    defdelegate add(self, value), to: Data.Set.BalancedTree
    defdelegate delete(self, value), to: Data.Set.BalancedTree
    defdelegate union(self, other), to: Data.Set.BalancedTree
    defdelegate intersection(self, other), to: Data.Set.BalancedTree
    defdelegate difference(self, other), to: Data.Set.BalancedTree
    defdelegate subset?(self, other), to: Data.Set.BalancedTree
    defdelegate disjoint?(self, other), to: Data.Set.BalancedTree
  end

  defimpl P.Count do
    defdelegate count(self), to: Data.Set.BalancedTree
  end

  defimpl P.Reduce do
    defdelegate reduce(self, acc, fun), to: Data.Set.BalancedTree
  end

  defimpl P.ToList do
    defdelegate to_list(self), to: Data.Set.BalancedTree
  end

  defimpl P.Empty do
    defdelegate empty?(self), to: Data.Set.BalancedTree
    defdelegate clear(self), to: Data.Set.BalancedTree
  end

  defimpl P.Contains do
    defdelegate contains?(self, value), to: Data.Set.BalancedTree, as: :member?
  end

  defimpl P.Sequence do
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

  defimpl Enumerable do
    use Data.Enumerable
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(set, opts) do
      concat ["#Set<", Kernel.inspect(Data.Set.BalancedTree.to_list(set), opts), ">"]
    end
  end
end

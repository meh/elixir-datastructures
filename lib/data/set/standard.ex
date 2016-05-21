#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Set.Standard do
  defstruct [:set]

  def new do
    %__MODULE__{set: :sets.new}
  end

  def new(enum_or_set) do
    if :sets.is_set(enum_or_set) do
      %__MODULE__{set: enum_or_set}
    else
      %__MODULE__{set: Data.to_list(enum_or_set) |> :sets.from_list}
    end
  end

  def member?(%__MODULE__{set: self}, element) do
    :sets.is_element(element, self)
  end

  def empty?(%__MODULE__{set: self}) do
    :sets.size(self) == 0
  end

  def clear(_) do
    %__MODULE__{set: :sets.new}
  end

  def add(%__MODULE__{set: self}, element) do
    %__MODULE__{set: :sets.add_element(element, self)}
  end

  def delete(%__MODULE__{set: self}, element) do
    %__MODULE__{set: :sets.del_element(element, self)}
  end

  def union(%__MODULE__{set: self}, %__MODULE__{set: other}) do
    %__MODULE__{set: :sets.union(self, other)}
  end

  def union(%__MODULE__{set: self}, other) do
    %__MODULE__{set: :sets.union(self, Data.to_list(other) |> :sets.from_list)}
  end

  def intersection(%__MODULE__{set: self}, %__MODULE__{set: other}) do
    %__MODULE__{set: :sets.intersection(self, other)}
  end

  def intersection(%__MODULE__{set: self}, other) do
    %__MODULE__{set: :sets.intersection(self, Data.to_list(other) |> :sets.from_list)}
  end

  def difference(%__MODULE__{set: self}, %__MODULE__{set: other}) do
    %__MODULE__{set: :sets.subtract(self, other)}
  end

  def difference(%__MODULE__{set: self}, other) do
    %__MODULE__{set: :sets.subtract(self, Data.to_list(other) |> :sets.from_list)}
  end

  def subset?(%__MODULE__{set: self}, %__MODULE__{set: other}) do
    :sets.is_subset(other, self)
  end

  def subset?(%__MODULE__{set: self}, other) do
    :sets.is_subset(Data.to_list(other) |> :sets.from_list, self)
  end

  def disjoint?(%__MODULE__{set: self}, %__MODULE__{set: other}) do
    :sets.is_disjoint(other, self)
  end

  def disjoint?(%__MODULE__{set: self}, other) do
    :sets.is_disjoint(Data.to_list(other) |> :sets.from_list, self)
  end

  def size(%__MODULE__{set: self}) do
    :sets.size(self)
  end

  def reduce(%__MODULE__{set: self}, acc, fun) do
    :sets.fold(fun, acc, self)
  end

  def to_list(%__MODULE__{set: self}) do
    Data.Set.List.new(:sets.to_list(self))
  end

  ## Specific functions

  def filter(%__MODULE__{set: self}, pred) do
    %__MODULE__{set: :sets.filter(pred, self)}
  end

  alias Data.Protocol, as: P

  defimpl P.Set do
    defdelegate add(self, value), to: Data.Set.Standard
    defdelegate delete(self, value), to: Data.Set.Standard
    defdelegate union(self, other), to: Data.Set.Standard
    defdelegate intersection(self, other), to: Data.Set.Standard
    defdelegate difference(self, other), to: Data.Set.Standard
    defdelegate subset?(self, other), to: Data.Set.Standard
    defdelegate disjoint?(self, other), to: Data.Set.Standard
  end

  defimpl P.Count do
    defdelegate count(self), to: Data.Set.Standard
  end

  defimpl P.Reduce do
    defdelegate reduce(self, acc, fun), to: Data.Set.Standard
  end

  defimpl P.ToList do
    defdelegate to_list(self), to: Data.Set.Standard
  end

  defimpl P.Empty do
    defdelegate empty?(self), to: Data.Set.Standard
    defdelegate clear(self), to: Data.Set.Standard
  end

  defimpl P.Contains do
    defdelegate contains?(self, key), to: Data.Set.Standard, as: :member?
  end

  defimpl P.Sequence do
    def first(self) do
      Data.Set.Standard.reduce(self, nil, fn(x, _) -> throw { :first, x } end)

      nil
    catch
      { :first, x } ->
        x
    end

    def next(self) do
      case Data.Set.Standard.to_list(self) do
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
      concat ["#Set<", Kernel.inspect(Data.Set.Standard.to_list(set), opts), ">"]
    end
  end
end

#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Set.Standard do
  alias Data.Protocol, as: P
  alias __MODULE__, as: T

  defstruct [:set]

  def new do
    %T{set: :sets.new}
  end

  def new(enum_or_set) do
    if :sets.is_set(enum_or_set) do
      %T{set: enum_or_set}
    else
      %T{set: Data.list(enum_or_set) |> :sets.from_list}
    end
  end

  def member?(%T{set: self}, element) do
    :sets.is_element(element, self)
  end

  def empty?(%T{set: self}) do
    :sets.size(self) == 0
  end

  def clear(_) do
    %T{set: :sets.new}
  end

  def add(%T{set: self}, element) do
    %T{set: :sets.add_element(element, self)}
  end

  def delete(%T{set: self}, element) do
    %T{set: :sets.del_element(element, self)}
  end

  def union(%T{set: self}, %T{set: other}) do
    %T{set: :sets.union(self, other)}
  end

  def union(%T{set: self}, other) do
    %T{set: :sets.union(self, Data.list(other) |> :sets.from_list)}
  end

  def intersection(%T{set: self}, %T{set: other}) do
    %T{set: :sets.intersection(self, other)}
  end

  def intersection(%T{set: self}, other) do
    %T{set: :sets.intersection(self, Data.list(other) |> :sets.from_list)}
  end

  def difference(%T{set: self}, %T{set: other}) do
    %T{set: :sets.subtract(self, other)}
  end

  def difference(%T{set: self}, other) do
    %T{set: :sets.subtract(self, Data.list(other) |> :sets.from_list)}
  end

  def subset?(%T{set: self}, %T{set: other}) do
    :sets.is_subset(other, self)
  end

  def subset?(%T{set: self}, other) do
    :sets.is_subset(Data.list(other) |> :sets.from_list, self)
  end

  def disjoint?(%T{set: self}, %T{set: other}) do
    :sets.is_disjoint(other, self)
  end

  def disjoint?(%T{set: self}, other) do
    :sets.is_disjoint(Data.list(other) |> :sets.from_list, self)
  end

  def size(%T{set: self}) do
    :sets.size(self)
  end

  def reduce(%T{set: self}, acc, fun) do
    :sets.fold(fun, acc, self)
  end

  def to_list(%T{set: self}) do
    :sets.to_list(self)
  end

  ## Specific functions

  def filter(%T{set: self}, pred) do
    %T{set: :sets.filter(pred, self)}
  end

  defimpl P.Set do
    defdelegate add(self, value), to: T
    defdelegate delete(self, value), to: T
    defdelegate union(self, other), to: T
    defdelegate intersection(self, other), to: T
    defdelegate difference(self, other), to: T
    defdelegate subset?(self, other), to: T
    defdelegate disjoint?(self, other), to: T
  end

  defimpl P.Count do
    defdelegate count(self), to: T, as: :size
  end

  defimpl P.Reduce do
    defdelegate reduce(self, acc, fun), to: T
  end

  defimpl P.ToList do
    defdelegate to_list(self), to: T
  end

  defimpl P.Empty do
    defdelegate empty?(self), to: T
    defdelegate clear(self), to: T
  end

  defimpl P.Contains do
    defdelegate contains?(self, key), to: T, as: :member?
  end

  defimpl P.Sequence do
    def first(self) do
      T.reduce(self, nil, fn(x, _) -> throw { :first, x } end)

      nil
    catch
      { :first, x } ->
        x
    end

    def next(self) do
      case T.to_list(self) do
        [] ->
          nil

        [_] ->
          nil

        [_ | tail] ->
          tail
      end
    end
  end

  defimpl P.Into do
    def into(self, value) do
      self |> T.add(value)
    end
  end

  defimpl Enumerable do
    use Data.Enumerable
  end

  defimpl Collectable do
    use Data.Collectable
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(set, opts) do
      concat ["#Set<", to_doc(T.to_list(set), opts), ">"]
    end
  end
end

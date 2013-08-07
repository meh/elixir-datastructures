#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Dictionary.BalancedTree do
  defrecordp :wrap, __MODULE__, dict: nil

  def new do
    wrap(dict: :gb_trees.empty)
  end

  def new({ 0, nil } = self) do
    wrap(dict: self)
  end

  def new({ length, tree } = self) when is_integer(length) and is_tuple(tree) do
    wrap(dict: self)
  end

  def new(enum) do
    wrap(dict: Data.to_list(enum) |> :orddict.from_list |> :gb_trees.from_orddict)
  end

  def has_key?(wrap(dict: self), key) do
    :gb_trees.is_defined(key, self)
  end

  def get(wrap(dict: self), key, default // nil) do
    case :gb_trees.lookup(key, self) do
      { :value, value } ->
        value

      :none ->
        default
    end
  end

  def get!(wrap(dict: self), key) do
    case :gb_trees.lookup(key, self) do
      { :value, value } ->
        value

      :none ->
        raise Data.Missing, key: key
    end
  end

  def put(wrap(dict: self), key, value) do
    wrap(dict: :gb_trees.enter(key, value, self))
  end

  def put_new(wrap(dict: self), key, value) do
    if :gb_trees.is_defined(key, self) do
      wrap(dict: self)
    else
      wrap(dict: :gb_trees.insert(key, value, self))
    end
  end

  def delete(wrap(dict: self), key) do
    wrap(dict: :gb_trees.delete_any(key, self))
  end

  def keys(wrap(dict: self)) do
    :gb_trees.keys(self)
  end

  def values(wrap(dict: self)) do
    :gb_trees.values(self)
  end

  def size(wrap(dict: self)) do
    :gb_trees.size(self)
  end

  def empty(_) do
    :gb_trees.empty
  end

  def to_list(wrap(dict: self)) do
    :gb_trees.to_list(self)
  end

  def member?(wrap(dict: self), { key, value }) do
    case :gb_trees.lookup(key, self) do
      { :value, ^value } ->
        true

      _ ->
        false
    end
  end

  def member?(wrap(dict: self), key) do
    :gb_trees.is_defined(key, self)
  end

  defmodule Sequence do
    defrecordp :seq, __MODULE__, iter: nil

    def new(dict) do
      seq(iter: :gb_trees.iterator(dict))
    end

    def first(seq(iter: iter)) do
      case :gb_trees.next(iter) do
        :none ->
          nil

        { key, value, _next } ->
          { key, value }
      end
    end

    def next(seq(iter: iter)) do
      case :gb_trees.next(iter) do
        :none ->
          nil

        { _key, _value, next } ->
          seq(iter: next)
      end
    end

    defimpl Data.Sequence, for: Sequence do
      defdelegate first(self), to: Sequence
      defdelegate next(self), to: Sequence
    end
  end

  def to_sequence(wrap(dict: self)) do
    Sequence.new(self)
  end
end

defimpl Data.Dictionary, for: Data.Dictionary.BalancedTree do
  defdelegate get(self, key), to: Data.Dictionary.BalancedTree
  defdelegate get(self, key, default), to: Data.Dictionary.BalancedTree
  defdelegate get!(self, key), to: Data.Dictionary.BalancedTree
  defdelegate put(self, key, value), to: Data.Dictionary.BalancedTree
  defdelegate delete(self, key), to: Data.Dictionary.BalancedTree
  defdelegate keys(self), to: Data.Dictionary.BalancedTree
  defdelegate values(self), to: Data.Dictionary.BalancedTree
end

defimpl Data.Counted, for: Data.Dictionary.BalancedTree do
  defdelegate count(self), to: Data.Dictionary.BalancedTree, as: :size
end

defimpl Data.Emptyable, for: Data.Dictionary.BalancedTree do
  def empty?(self) do
    Data.Dictionary.BalancedTree.size(self) == 0
  end

  defdelegate clear(self), to: Data.Dictionary.BalancedTree, as: :empty
end

defimpl Data.Reducible, for: Data.Dictionary.BalancedTree do
  def reduce(self, acc, fun) do
    Data.Seq.reduce(self, acc, fun)
  end
end

defimpl Data.Listable, for: Data.Dictionary.BalancedTree do
  defdelegate to_list(self), to: Data.Dictionary.BalancedTree
end

defimpl Data.Contains, for: Data.Dictionary.BalancedTree do
  defdelegate contains?(self, key), to: Data.Dictionary.BalancedTree, as: :member?
end

defimpl Data.Sequenceable, for: Data.Dictionary.BalancedTree do
  defdelegate to_sequence(self), to: Data.Dictionary.BalancedTree
end

defimpl Access, for: Data.Dictionary.BalancedTree do
  defdelegate access(self, key), to: Data.Dictionary.BalancedTree, as: :get
end

defimpl Enumerable, for: Data.Dictionary.BalancedTree do
  use Data.Enumerable
end

defimpl Inspect, for: Data.Dictionary.BalancedTree do
  import Inspect.Algebra

  def inspect(self, opts) do
    concat ["#Dictionary<", Kernel.inspect(Data.Dictionary.BalancedTree.to_list(self), opts), ">"]
  end
end

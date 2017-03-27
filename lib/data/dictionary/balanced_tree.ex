#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Dictionary.BalancedTree do
  alias Data.Protocol, as: P
  alias __MODULE__, as: T

  defstruct dict: nil

  def new do
    %T{dict: :gb_trees.empty}
  end

  def new({ 0, nil } = self) do
    %T{dict: self}
  end

  def new({ length, tree } = self) when is_integer(length) and is_tuple(tree) do
    %T{dict: self}
  end

  def new(enum) do
    %T{dict: Data.list(enum) |> :orddict.from_list |> :gb_trees.from_orddict}
  end

  def has_key?(%T{dict: self}, key) do
    :gb_trees.is_defined(key, self)
  end

  def fetch(%T{dict: self}, key) do
    case :gb_trees.lookup(key, self) do
      { :value, value } ->
        { :ok, value }

      :none ->
        :error
    end
  end

  def put(%T{dict: self}, key, value) do
    %T{dict: :gb_trees.enter(key, value, self)}
  end

  def put_new(%T{dict: self}, key, value) do
    if :gb_trees.is_defined(key, self) do
      %T{dict: self}
    else
      %T{dict: :gb_trees.insert(key, value, self)}
    end
  end

  def delete(%T{dict: self}, key) do
    %T{dict: :gb_trees.delete_any(key, self)}
  end

  def keys(%T{dict: self}) do
    :gb_trees.keys(self)
  end

  def values(%T{dict: self}) do
    :gb_trees.values(self)
  end

  def size(%T{dict: self}) do
    :gb_trees.size(self)
  end

  def empty(_) do
    :gb_trees.empty
  end

  def to_list(%T{dict: self}) do
    :gb_trees.to_list(self)
  end

  def member?(%T{dict: self}, { key, value }) do
    case :gb_trees.lookup(key, self) do
      { :value, ^value } ->
        true

      _ ->
        false
    end
  end

  def member?(%T{dict: self}, key) do
    :gb_trees.is_defined(key, self)
  end

  defmodule Sequence do
    defstruct [:iter]

    def new(dict) do
      %__MODULE__{iter: :gb_trees.iterator(dict)}
    end

    def first(%__MODULE__{iter: iter}) do
      case :gb_trees.next(iter) do
        :none ->
          nil

        { key, value, _next } ->
          { key, value }
      end
    end

    def next(%__MODULE__{iter: iter}) do
      case :gb_trees.next(iter) do
        :none ->
          nil

        { _key, _value, next } ->
          %__MODULE__{iter: next}
      end
    end

    defimpl P.Sequence do
      defdelegate first(self), to: Sequence
      defdelegate next(self), to: Sequence
    end
  end

  def to_sequence(%T{dict: self}) do
    Sequence.new(self)
  end

  defimpl P.Dictionary do
    defdelegate fetch(self, key), to: T
    defdelegate put(self, key, value), to: T
    defdelegate delete(self, key), to: T
    defdelegate keys(self), to: T
    defdelegate values(self), to: T
  end

  defimpl P.Count do
    defdelegate count(self), to: T, as: :size
  end

  defimpl P.Empty do
    def empty?(self) do
      T.size(self) == 0
    end

    defdelegate clear(self), to: T, as: :empty
  end

  defimpl P.Reduce do
    def reduce(self, acc, fun) do
      Data.Seq.reduce(self, acc, fun)
    end
  end

  defimpl P.ToList do
    defdelegate to_list(self), to: T
  end

  defimpl P.Contains do
    defdelegate contains?(self, key), to: T, as: :member?
  end

  defimpl P.ToSequence do
    defdelegate to_sequence(self), to: T
  end

  defimpl P.Into do
    def into(self, { key, value }) do
      self |> T.put(key, value)
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

    def inspect(self, opts) do
      concat ["#Dictionary<", to_doc(T.to_list(self), opts), ">"]
    end
  end
end

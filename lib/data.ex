#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data do
  @spec contains?(Data.Contains.t, any) :: any
  def contains?(self, what) do
    Data.Contains.contains?(self, what)
  end

  @spec seq(Data.Sequence.t | Data.Sequenceable.t | Data.Listable.t) :: Data.Sequence.t
  def seq(self) when is_list(self) do
    self
  end

  def seq(self) do
    cond do
      implements?(self, Data.Sequence) ->
        self

      implements?(self, Data.Sequenceable) ->
        Data.Sequenceable.to_sequence(self)

      true ->
        to_list(self)
    end
  end

  @spec first(Data.Sequence.t) :: any
  def first(self) do
    Data.Sequence.first(self)
  end

  @spec next(Data.Sequence.t) :: Data.Sequence.t
  def next(self) do
    Data.Sequence.next(self)
  end

  @spec peek(Data.Peekable.t)      :: any
  @spec peek(Data.Peekable.t, any) :: any
  def peek(self, default // nil) do
    Data.Peekable.peek(self, default)
  end

  @spec peek!(Data.Peekable.t) :: any | no_return
  def peek!(self) do
    Data.Peekable.peek!(self)
  end

  @spec reduce(Data.Foldable.t, any, ((any, any) -> any)) :: any
  def reduce(self, acc, fun) do
    Data.Foldable.foldl(self, acc, fun)
  end

  @spec foldl(Data.Foldable.t, any, ((any, any) -> any)) :: any
  def foldl(self, acc, fun) do
    Data.Foldable.foldl(self, acc, fun)
  end

  @spec foldr(Data.Foldable.t, any, ((any, any) -> any)) :: any
  def foldr(self, acc, fun) do
    Data.Foldable.foldr(self, acc, fun)
  end

  @spec member?(Enumerable.t, any) :: Enumerable.t
  def member?(self, value) do
    Enum.member?(self, value)
  end

  @spec empty?(Data.Empytable.t) :: Data.Emptyable.t
  def empty?(self) do
    Data.Emptyable.empty?(self)
  end

  @spec clear(Data.Emptyable.t) :: Data.Emptyable.t
  def clear(self) do
    Data.Emptyable.clear(self)
  end

  @spec count(Data.Counted.t | Enumerable.t) :: Data.Counted.t | Enumerable.t
  def count(self) do
    if implements?(self, Data.Counted) do
      Data.Counted.count(self)
    else
      Enum.count(self)
    end
  end

  @spec reverse(Data.Reversible.t) :: Data.Reversible.t
  def reverse(self) do
    Data.Reversible.reverse(self)
  end

  @spec to_list(list | Data.Listable.t | Enumerable.t) :: list
  def to_list(self) when is_list(self) do
    self
  end

  def to_list(self) do
    if implements?(self, Enumerable) do
      Enum.to_list(self)
    else
      Data.Listable.to_list(self)
    end
  end

  @spec implements?(record | list, module) :: boolean
  def implements?(self, protocol) when is_record(self) do
    Code.ensure_loaded? Module.concat(protocol, elem(self, 0))
  end

  def implements?(self, protocol) when is_list(self) do
    Code.ensure_loaded? Module.concat(protocol, List)
  end

  @spec implements?(record | list, module, [{ atom, non_neg_integer }]) :: boolean
  def implements?(self, protocol, [{ name, arity }]) when is_record(self) do
    implements?(self, protocol) and function_exported? Module.concat(protocol, elem(self, 0)), name, arity
  end

  def implements?(self, protocol, [{ name, arity }]) when is_list(self) do
    implements?(self, protocol) and function_exported? Module.concat(protocol, List), name, arity
  end
end

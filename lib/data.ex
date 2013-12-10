#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data do
  @spec contains?(Data.Contains.t | Data.Sequence.t, any) :: any
  def contains?(self, what) do
    cond do
      mod = Data.Contains.impl_for(self) ->
        mod.contains?(self, what)

      Enumerable.impl_for(self) ->
        Enum.member?(self, what)

      true ->
        Data.Seq.contains?(self, what)
    end
  end

  @spec seq(Data.Sequence.t | Data.Sequenceable.t | Data.Listable.t) :: Data.Sequence.t
  def seq([]) do
    nil
  end

  def seq(nil) do
    nil
  end

  def seq(self) when is_list(self) do
    self
  end

  def seq(self) when is_binary(self) do
    self
  end

  def seq(self) do
    cond do
      empty?(self) ->
        nil

      Data.Sequence.impl_for(self) ->
        self

      mod = Data.Sequenceable.impl_for(self) ->
        mod.to_sequence(self)

      true ->
        to_list(self)
    end
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

  @spec reduce(Data.Reducible.t, any, ((any, any) -> any)) :: any
  def reduce(self, acc, fun) do
    Data.Reducible.reduce(self, acc, fun)
  end

  @spec foldr(Data.Foldable.t, any, ((any, any) -> any)) :: any
  def foldr(self, acc, fun) do
    Data.Foldable.foldr(self, acc, fun)
  end

  @spec empty?(Data.Empytable.t | Data.Sequence.t) :: Data.Emptyable.t
  def empty?(nil) do
    true
  end

  def empty?([]) do
    true
  end

  def empty?(list) when is_list(list) do
    false
  end

  def empty?(self) do
    cond do
      mod = Data.Emptyable.impl_for(self) ->
        mod.empty?(self)

      mod = Data.Sequenceable.impl_for(self) ->
        mod.to_sequence(self) == nil

      mod = Data.Listable.impl_for(self) ->
        mod.to_list(self) == []

      true ->
        false
    end
  end

  @spec clear(Data.Emptyable.t) :: Data.Emptyable.t
  def clear(self) do
    Data.Emptyable.clear(self)
  end

  @spec count(Data.Counted.t | Data.Sequence.t | Enumerable.t) :: Data.Counted.t | Enumerable.t
  def count(self) do
    cond do
      mod = Data.Counted.impl_for(self) ->
        mod.count(self)

      Data.Sequence.impl_for(self) ->
        Data.Seq.count(self)

      Data.Sequenceable.impl_for(self) ->
        Data.Seq.count(self)

      Enumerable.impl_for(self) ->
        Enum.count(self)
    end
  end

  @spec count(Data.Sequence.t | Enumerable.t, (any -> boolean)) :: Data.Counted.t | Enumerable.t
  def count(self, pred) do
    cond do
      Data.Sequence.impl_for(self) ->
        Data.Seq.count(self, pred)

      Data.Sequenceable.impl_for(self) ->
        Data.Seq.count(self, pred)

      Enumerable.impl_for(self) ->
        Enum.count(self, pred)
    end
  end

  @spec reverse(Data.Reversible.t) :: Data.Reversible.t
  def reverse(self) do
    Data.Reversible.reverse(self)
  end

  @spec to_list(list | Data.Listable.t | Data.Sequence.t | Enumerable.t) :: list
  def to_list(self) when is_list(self) do
    self
  end

  def to_list(nil) do
    []
  end

  def to_list(self) do
    cond do
      mod = Data.Listable.impl_for(self) ->
        mod.to_list(self)

      mod = Data.Sequence.impl_for(self) ->
        mod.to_list(self)

      Data.Sequenceable.impl_for(self) ->
        Data.Seq.to_list(self)

      Enumerable.impl_for(self) ->
        Enum.to_list(self)
    end
  end
end

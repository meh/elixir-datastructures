#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data do
  alias Data.Protocol, as: P
  alias Data.Error, as: E

  defmacro __using__(_opts) do
    quote location: :keep do
      alias Data.Dict
      alias Data.Set
      alias Data.Queue
      alias Data.Seq
      alias Data.Set
      alias Data.Stack
    end
  end

  @spec contains?(P.Contains.t | P.Sequence.t, any) :: any
  def contains?(self, what) do
    cond do
      mod = P.Contains.impl_for(self) ->
        mod.contains?(self, what)

      Enumerable.impl_for(self) ->
        Enum.member?(self, what)

      true ->
        Data.Seq.contains?(self, what)
    end
  end

  @spec seq(P.Sequence.t | P.ToSequence.t | P.ToList.t) :: P.Sequence.t
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

      P.Sequence.impl_for(self) ->
        self

      mod = P.ToSequence.impl_for(self) ->
        mod.to_sequence(self)

      true ->
        to_list(self)
    end
  end

  @spec peek(P.Peek.t)      :: any
  @spec peek(P.Peek.t, any) :: any
  def peek(self, default \\ nil) do
    case P.Peek.peek(self) do
      { :value, value } ->
        value

      :empty ->
        default
    end
  end

  @spec peek!(P.Peek.t) :: any | no_return
  def peek!(self) do
    case P.Peek.peek(self) do
      { :value, value } ->
        value

      :empty ->
        raise E.Empty
    end
  end

  @spec reduce(P.Reduce.t, any, ((any, any) -> any)) :: any
  def reduce(self, acc, fun) do
    P.Reduce.reduce(self, acc, fun)
  end

  @spec empty?(P.Empty.t | P.Sequence.t) :: P.t
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
      mod = P.Empty.impl_for(self) ->
        mod.empty?(self)

      mod = P.ToSequence.impl_for(self) ->
        mod.to_sequence(self) == nil

      mod = P.ToList.impl_for(self) ->
        mod.to_list(self) == []

      true ->
        false
    end
  end

  @spec clear(P.Empty.t) :: P.Empty.t
  def clear(self) do
    P.Empty.clear(self)
  end

  @spec count(P.Count.t | P.Sequence.t | Enumerable.t) :: P.Count.t | Enumerable.t
  def count(self) do
    cond do
      mod = P.Count.impl_for(self) ->
        mod.count(self)

      P.Sequence.impl_for(self) ->
        Seq.count(self)

      P.ToSequence.impl_for(self) ->
        Seq.count(self)

      Enumerable.impl_for(self) ->
        Enum.count(self)
    end
  end

  @spec count(P.Sequence.t | Enumerable.t, (any -> boolean)) :: P.Count.t | Enumerable.t
  def count(self, pred) do
    cond do
      P.Sequence.impl_for(self) ->
        Seq.count(self, pred)

      P.ToSequence.impl_for(self) ->
        Seq.count(self, pred)

      Enumerable.impl_for(self) ->
        Enum.count(self, pred)
    end
  end

  @spec reverse(P.Reverse.t) :: P.Reverse.t
  def reverse(self) do
    P.Reverse.reverse(self)
  end

  @spec to_list(list | P.ToList.t | P.Sequence.t | Enumerable.t) :: list
  def to_list(self) when is_list(self) do
    self
  end

  def to_list(nil) do
    []
  end

  def to_list(self) do
    cond do
      mod = P.ToList.impl_for(self) ->
        mod.to_list(self)

      mod = P.Sequence.impl_for(self) ->
        mod.to_list(self)

      P.ToSequence.impl_for(self) ->
        Seq.to_list(self)

      Enumerable.impl_for(self) ->
        Enum.to_list(self)
    end
  end
end

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

  alias Data.Seq

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

  def seq(value) when value |> is_atom or value |> is_list or value |> is_binary do
    value
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
        list(self)
    end
  end

  @spec list(list | P.ToList.t | P.Sequence.t | Enumerable.t) :: list
  def list(value) when value |> is_list do
    value
  end

  def list(nil) do
    []
  end

  def list(value) do
    cond do
      mod = P.ToList.impl_for(value) ->
        mod.to_list(value)

      P.Sequence.impl_for(value) ->
        Seq.to_list(value)

      P.ToSequence.impl_for(value) ->
        Seq.to_list(value)

      P.Reduce.impl_for(value) ->
        reduce(value, [], &[&1 | &2]) |> reverse

      Enumerable.impl_for(value) ->
        Enum.to_list(value)

      true ->
        [value]
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

  def empty?(list) when list |> is_list do
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

      Enumerable.impl_for(self) ->
        Enum.count(self)

      P.Sequence.impl_for(self) ->
        Seq.count(self)

      P.ToSequence.impl_for(self) ->
        Seq.count(self)

      P.Reduce.impl_for(self) ->
        P.Reduce.reduce(self, 0, &(&1 + 1))
    end
  end

  @spec count(P.Sequence.t | Enumerable.t, (any -> boolean)) :: P.Count.t | Enumerable.t
  def count(self, pred) do
    cond do
      Enumerable.impl_for(self) ->
        Enum.count(self, pred)

      P.Sequence.impl_for(self) ->
        Seq.count(self, pred)

      P.ToSequence.impl_for(self) ->
        Seq.count(self, pred)

      P.Reduce.impl_for(self) ->
        P.Reduce.reduce(self, 0, fn value, acc ->
          if pred.(value) do
            acc + 1
          else
            acc
          end
        end)
    end
  end

  @spec reverse(P.Reverse.t) :: P.Reverse.t
  def reverse(self) do
    P.Reverse.reverse(self)
  end
end

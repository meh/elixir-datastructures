#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Seq do
  alias Data.Sequence, as: S
  alias Data.Emptyable, as: E

  defdelegate first(sequence), to: S
  defdelegate next(sequence), to: S

  @spec all?(S.t, (any -> boolean)) :: boolean
  def all?(sequence, fun // fn(x) -> x end) do
    do_all?(Data.seq(sequence), fun)
  end

  defp do_all?(nil, _) do
    true
  end

  defp do_all?(sequence, fun) do
    if fun.(S.first(sequence)) do
      do_all?(S.next(sequence), fun)
    else
      false
    end
  end

  @spec any?(S.t, (any -> as_boolean(any))) :: boolean
  def any?(sequence, fun // fn(x) -> x end) do
    do_any?(Data.seq(sequence), fun)
  end

  defp do_any?(nil, _) do
    false
  end

  defp do_any?(sequence, fun) do
    if fun.(S.first(sequence)) do
      true
    else
      do_any?(S.next(sequence), fun)
    end
  end

  @spec at(S.t, non_neg_integer, any) :: any
  def at(sequence, index, default // nil) do
    do_at(0, Data.seq(sequence), index, default)
  end

  defp do_at(_, nil, _, default) do
    default
  end

  defp do_at(current, sequence, index, _) when current == index do
    S.first(sequence)
  end

  defp do_at(current, sequence, index, default) do
    do_at(current + 1, S.next(sequence), index, default)
  end

  @spec find(S.t, (any -> as_boolean(any)))      :: any
  @spec find(S.t, any, (any -> as_boolean(any))) :: any
  def find(sequence, if_none // nil, fun) do
    do_find(Data.seq(sequence), if_none, fun)
  end

  defp do_find(nil, if_none, _) do
    if_none
  end

  defp do_find(sequence, if_none, fun) do
    value = S.first(sequence)

    if fun.(value) do
      value
    else
      do_find(S.next(sequence), if_none, fun)
    end
  end

  @spec find_value(S.t, (any -> any))      :: any
  @spec find_value(S.t, any, (any -> any)) :: any
  def find_value(sequence, if_none // nil, fun) do
    do_find_value(Data.seq(sequence), if_none, fun)
  end

  defp do_find_value(nil, if_none, _) do
    if_none
  end

  defp do_find_value(sequence, if_none, fun) do
    value = fun.(S.first(sequence))

    if value do
      value
    else
      do_find_value(sequence, if_none, fun)
    end
  end

  @spec find_index(S.t, (any -> as_boolean(any))) :: any
  def find_index(sequence, fun) do
    do_find_index(0, Data.seq(sequence), fun)
  end

  def do_find_index(_, nil, _) do
    nil
  end

  def do_find_index(index, sequence, fun) do
    if fun.(S.first(sequence)) do
      index
    else
      do_find_index(index + 1, S.next(sequence), fun)
    end
  end

  @spec contains?(S.t, any) :: boolean
  @spec contains?(S.t, any, (any -> any)) :: boolean
  def contains?(sequence, value, fun // fn(x) -> x end) do
    do_contains?(Data.seq(sequence), value, fun)
  end

  def do_contains?(nil, _, _) do
    false
  end

  def do_contains?(sequence, value, fun) do
    if fun.(S.first(sequence)) == value do
      true
    else
      do_contains?(S.next(sequence), value, fun)
    end
  end

  @spec drop(S.t, non_neg_integer) :: S.t
  def drop(sequence, count) do
    do_drop(Data.seq(sequence), count)
  end

  defp do_drop(nil, _) do
    nil
  end

  defp do_drop(sequence, 0) do
    sequence
  end

  defp do_drop(sequence, count) do
    do_drop(S.next(sequence), count - 1)
  end

  @spec drop_while(S.t, (any -> as_boolean(term))) :: S.t
  def drop_while(sequence, fun) do
    do_drop_while(Data.seq(sequence), fun)
  end

  defp do_drop_while(nil, _) do
    nil
  end

  defp do_drop_while(sequence, fun) do
    if fun.(S.first(sequence)) do
      do_drop_while(S.next(sequence), fun)
    else
      sequence
    end
  end

  @spec take(S.t, non_neg_integer) :: S.t
  def take(sequence, count) do
    Data.seq(do_take([], Data.seq(sequence), count))
  end

  defp do_take(acc, nil, _) do
    acc |> :lists.reverse
  end

  defp do_take(acc, _, 0) do
    acc |> :lists.reverse
  end

  defp do_take(acc, sequence, count) do
    [S.first(sequence) | acc] |> do_take(S.next(sequence), count - 1)
  end

  @spec take_while(S.t, (any -> as_boolean(any))) :: S.t
  def take_while(sequence, fun) do
    Data.seq(do_take_while([], Data.seq(sequence), fun))
  end

  defp do_take_while(acc, nil, _) do
    acc |> :lists.reverse
  end

  defp do_take_while(acc, sequence, fun) do
    value = S.first(sequence)

    if fun.(value) do
      [value | acc] |> do_take_while(S.next(sequence), fun)
    else
      acc |> :lists.reverse
    end
  end

  @spec each(S.t, (any -> none)) :: none
  def each(sequence, fun) do
    do_each(Data.seq(sequence), fun)
  end

  defp do_each(nil, _) do
    nil
  end

  defp do_each(sequence, fun) do
    fun.(S.first(sequence))

    do_each(S.next(sequence), fun)
  end

  @spec select(S.t, (any -> as_boolean(term))) :: S.t
  def select(sequence, fun) do
    do_select([], Data.seq(sequence), fun)
  end

  defp do_select(acc, nil, _) do
    acc |> :lists.reverse
  end

  defp do_select(acc, sequence, fun) do
    value = S.first(sequence)

    if fun.(value) do
      do_select([value | acc], S.next(sequence), fun)
    else
      do_select(acc, S.next(sequence), fun)
    end
  end

  @spec reject(S.t, (any -> as_boolean(term))) :: S.t
  def reject(sequence, fun) do
    do_reject([], Data.seq(sequence), fun)
  end

  defp do_reject(acc, nil, _) do
    acc |> :lists.reverse
  end

  defp do_reject(acc, sequence, fun) do
    value = S.first(sequence)

    if fun.(value) do
      do_reject(acc, S.next(sequence), fun)
    else
      do_reject([value | acc], S.next(sequence), fun)
    end
  end

  @spec map(S.t, (any -> any)) :: S.t
  def map(sequence, fun) do
    do_map([], Data.seq(sequence), fun)
  end

  defp do_map(acc, nil, _) do
    acc |> :lists.reverse
  end

  defp do_map(acc, sequence, fun) do
    [fun.(S.first(sequence)) | acc] |> do_map(S.next(sequence), fun)
  end

  def reverse(sequence) do
    do_reverse([], Data.seq(sequence))
  end

  defp do_reverse(acc, nil) do
    acc
  end

  defp do_reverse(acc, sequence) do
    [S.first(sequence) | acc] |> do_reverse(S.next(sequence))
  end

  @spec reduce(S.t, any, (any, any -> any)) :: any
  def reduce(sequence, acc, fun) do
    do_reduce(acc, Data.seq(sequence), fun)
  end

  defp do_reduce(acc, nil, _) do
    acc
  end

  defp do_reduce(acc, sequence, fun) do
    fun.(S.first(sequence), acc) |> do_reduce(S.next(sequence), fun)
  end

  @spec sort(S.t) :: S.t
  def sort(sequence) when is_list(sequence) do
    :lists.sort(sequence)
  end

  def sort(sequence) do
    to_list(sequence) |> sort
  end

  @spec sort(S.t, (any, any -> boolean)) :: S.t
  def sort(sequence, fun)

  def sort(sequence, fun) when is_list(sequence) do
    :lists.sort(fun, sequence)
  end

  def sort(sequence, fun) do
    to_list(sequence) |> sort(fun)
  end

  @spec empty?(S.t) :: boolean
  def empty?(sequence) do
    Data.seq(sequence) == nil
  end

  @spec count(S.t) :: non_neg_integer
  def count(sequence) do
    do_count(0, Data.seq(sequence))
  end

  defp do_count(acc, nil) do
    acc
  end

  defp do_count(acc, seq) do
    do_count(acc + 1, Data.Sequence.next(seq))
  end

  @spec zip(S.t, S.t) :: S.t
  def zip(sequence1, sequence2) do
    do_zip([], Data.seq(sequence1), Data.seq(sequence2))
  end

  defp do_zip(acc, nil, _) do
    acc |> :lists.reverse
  end

  defp do_zip(acc, sequence, nil) do
    [{ S.first(sequence), nil } | acc] |> do_zip(S.next(sequence), nil)
  end

  defp do_zip(acc, sequence1, sequence2) do
    [{ S.first(sequence1), S.first(sequence2) } | acc] |> do_zip(S.next(sequence1), S.next(sequence2))
  end

  @spec max(S.t) :: any
  def max(sequence) when is_list(sequence) do
    :lists.max(sequence)
  end

  def max(sequence) do
    if Data.empty?(sequence) do
      raise Data.Empty
    else
      reduce Data.seq(sequence), S.first(sequence), fn current, max ->
        if current > max, do: current, else: max
      end
    end
  end

  @spec max(S.t, (any -> any)) :: any
  def max(sequence, fun) do
    { max, _ } = reduce Data.seq(sequence), fun.(S.first(sequence)), fn current, { _, max } = old ->
      value = fun.(current)

      if value > max, do: { current, value }, else: old
    end

    max
  end

  @spec min(S.t) :: any
  def min(sequence) when is_list(sequence) do
    :lists.min(sequence)
  end

  def min(sequence) do
    if Data.empty?(sequence) do
      raise Data.Empty
    else
      reduce Data.seq(sequence), S.first(sequence), fn current, min ->
        if current < min, do: current, else: min
      end
    end
  end

  @spec min(S.t, (any -> any)) :: any
  def min(sequence, fun) do
    { min, _ } = reduce Data.seq(sequence), fun.(S.first(sequence)), fn current, { _, min } = old ->
      value = fun.(current)

      if value < min, do: { current, value }, else: old
    end

    min
  end

  @spec uniq(S.t)               :: S.t
  @spec uniq(S.t, (any -> any)) :: S.t
  def uniq(sequence, fun // fn x -> x end) do
    { list, _ } = reduce Data.seq(sequence), { [], [] }, fn(current, { acc, fun_acc }) ->
      value = fun.(current)

      if :lists.member(value, fun_acc) do
        { acc, fun_acc }
      else
        { [current | acc], [value | fun_acc] }
      end
    end

    :lists.reverse list
  end

  @spec count(S.t, (any -> boolean)) :: non_neg_integer
  def count(sequence, predicate) do
    do_count(0, sequence, predicate)
  end

  defp do_count(acc, nil, _) do
    acc
  end

  defp do_count(acc, seq, pred) do
    if pred.(S.first(seq)) do
      do_count(acc + 1, S.next(seq), pred)
    else
      do_count(acc, S.next(seq), pred)
    end
  end

  @spec to_list(S.t) :: list
  def to_list(sequence) do
    do_to_list([], sequence)
  end

  defp do_to_list(acc, nil) do
    acc |> :lists.reverse
  end

  defp do_to_list(acc, seq) do
    [S.first(seq) | acc] |> do_to_list(S.next(seq))
  end
end

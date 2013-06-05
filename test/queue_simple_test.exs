Code.require_file "test_helper.exs", __DIR__

defmodule QueueSimpleTest do
  use ExUnit.Case, async: true
  alias Queue, as: Q
  alias Data.Queue.Simple, as: QS

  test :new do
    assert match?({ _, [], [] }, QS.new)
    assert match?({ _, [], [1, 2, 3] }, QS.new(1 .. 3))
  end

  test :empty? do
    assert QS.new |> Q.empty?
    refute QS.new(1 .. 3) |> Q.empty?
  end

  test :enq do
    assert match?({ _, [], [23] }, QS.new |> Q.enq(23))
    assert match?({ _, [], [23, 42] }, QS.new |> Q.enq(23) |> Q.enq(42))
    assert match?({ _, [1337], [23, 42] }, QS.new |> Q.enq(23) |> Q.enq(42) |> Q.enq(1337))
  end

  test :deq do
    assert match?({ :empty, { _, [], [] } }, QS.new |> Q.deq(:empty))
    assert match?({ 23, { _, [], [] } }, QS.new |> Q.enq(23) |> Q.deq)
    assert match?({ 23, { _, [], [42] } }, QS.new |> Q.enq(23) |> Q.enq(42) |> Q.deq)
    assert match?({ 23, { _, [1337], [42] } }, QS.new |> Q.enq(23) |> Q.enq(42) |> Q.enq(1337) |> Q.deq)
  end

  test :deq! do
    assert_raise Q.Empty, fn ->
      QS.new |> Q.deq!
    end
  end

  test :peek do
    assert QS.new |> Q.peek(:empty) == :empty
    assert QS.new |> Q.enq(23) |> Q.peek == 23
  end

  test :peek! do
    assert_raise Q.Empty, fn ->
      QS.new |> Q.peek!
    end
  end

  test :reverse do
    assert match?({ _, [23], [] }, QS.new |> Q.enq(23) |> Q.reverse)
    assert match?({ _, [23, 42], [1337] }, QS.new |> Q.enq(23) |> Q.enq(42) |> Q.enq(1337) |> Q.reverse)
  end

  test :member? do
    refute QS.new |> Q.member?(23)
    assert QS.new |> Q.enq(23) |> Q.member?(23)
    assert QS.new |> Q.enq(23) |> Q.enq(42) |> Q.enq(1337) |> Q.member?(1337)
  end

  test :size do
    assert QS.new |> Q.size == 0
    assert QS.new |> Q.enq(23) |> Q.size == 1
    assert QS.new |> Q.enq(23) |> Q.enq(42) |> Q.size == 2
    assert QS.new |> Q.enq(23) |> Q.enq(42) |> Q.enq(1337) |> Q.size == 3
  end

  test :foldl do
    assert QS.new |> Q.foldl([], [&1 | &2]) == []
    assert QS.new |> Q.enq(23) |> Q.foldl([], [&1 | &2]) == [23]
    assert QS.new |> Q.enq(23) |> Q.enq(42) |> Q.foldl([], [&1 | &2]) == [42, 23]
    assert QS.new |> Q.enq(23) |> Q.enq(42) |> Q.enq(1337) |> Q.foldl([], [&1 | &2]) == [1337, 42, 23]
  end

  test :foldr do
    assert QS.new |> Q.foldr([], [&1 | &2]) == []
    assert QS.new |> Q.enq(23) |> Q.foldr([], [&1 | &2]) == [23]
    assert QS.new |> Q.enq(23) |> Q.enq(42) |> Q.foldr([], [&1 | &2]) == [23, 42]
    assert QS.new |> Q.enq(23) |> Q.enq(42) |> Q.enq(1337) |> Q.foldr([], [&1 | &2]) == [23, 42, 1337]
  end

  test :to_list do
    assert QS.new(1 .. 3) |> Q.to_list == [1, 2, 3]
    assert QS.new |> Q.enq(23) |> Q.to_list == [23]
    assert QS.new |> Q.enq(23) |> Q.enq(42) |> Q.to_list == [23, 42]
    assert QS.new |> Q.enq(23) |> Q.enq(42) |> Q.enq(1337) |> Q.to_list == [23, 42, 1337]
  end

  test :inspect do
    assert QS.new |> inspect == "#Queue<[]>"
    assert QS.new |> Q.enq(23) |> inspect == "#Queue<[23]>"
    assert QS.new |> Q.enq(23) |> Q.enq(42) |> inspect == "#Queue<[23,42]>"
    assert QS.new |> Q.enq(23) |> Q.enq(42) |> Q.enq(1337) |> inspect == "#Queue<[23,42,1337]>"
  end

#  doctest Data.Queue.Simple
end

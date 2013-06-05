Code.require_file "test_helper.exs", __DIR__

defmodule StackSimpleTest do
  use ExUnit.Case, async: true
  alias Stack, as: S
  alias Data.Stack.Simple, as: SS

  test :new do
    assert match?({ _, [] }, SS.new)
    assert match?({ _, [1, 2, 3] }, SS.new(1 .. 3))
  end

  test :empty? do
    assert SS.new |> S.empty?
    refute SS.new(1 .. 3) |> S.empty?
  end

  test :push do
    assert match?({ _, [23] }, SS.new |> S.push(23))
    assert match?({ _, [42, 23] }, SS.new |> S.push(23) |> S.push(42))
    assert match?({ _, [1337, 42, 23] }, SS.new |> S.push(23) |> S.push(42) |> S.push(1337))
  end

  test :pop do
    assert match?({ :empty, { _, [] } }, SS.new |> S.pop(:empty))
    assert match?({ 23, { _, [] } }, SS.new |> S.push(23) |> S.pop)
    assert match?({ 42, { _, [23] } }, SS.new |> S.push(23) |> S.push(42) |> S.pop)
    assert match?({ 1337, { _, [42, 23] } }, SS.new |> S.push(23) |> S.push(42) |> S.push(1337) |> S.pop)
  end

  test :pop! do
    assert_raise Stack.Empty, fn ->
      SS.new |> S.pop!
    end
  end

  test :peek do
    assert SS.new |> S.peek(:empty) == :empty
    assert SS.new |> S.push(23) |> S.peek == 23
  end

  test :peek! do
    assert_raise Stack.Empty, fn ->
      SS.new |> S.peek!
    end
  end

  test :reverse do
    assert match?({ _, [23, 42] }, SS.new |> S.push(23) |> S.push(42) |> S.reverse)
    assert match?({ _, [23, 42, 1337] }, SS.new |> S.push(23) |> S.push(42) |> S.push(1337) |> S.reverse)
  end

  test :member? do
    refute SS.new |> S.member?(23)
    assert SS.new |> S.push(23) |> S.member?(23)
    assert SS.new |> S.push(23) |> S.push(42) |> S.push(1337) |> S.member?(1337)
  end

  test :size do
    assert SS.new |> S.size == 0
    assert SS.new |> S.push(23) |> S.size == 1
    assert SS.new |> S.push(23) |> S.push(42) |> S.size == 2
    assert SS.new |> S.push(23) |> S.push(42) |> S.push(1337) |> S.size == 3
  end

  test :foldl do
    assert SS.new |> S.foldl([], [&1 | &2]) == []
    assert SS.new |> S.push(23) |> S.foldl([], [&1 | &2]) == [23]
    assert SS.new |> S.push(23) |> S.push(42) |> S.foldl([], [&1 | &2]) == [23, 42]
    assert SS.new |> S.push(23) |> S.push(42) |> S.push(1337) |> S.foldl([], [&1 | &2]) == [23, 42, 1337]
  end

  test :foldr do
    assert SS.new |> S.foldr([], [&1 | &2]) == []
    assert SS.new |> S.push(23) |> S.foldr([], [&1 | &2]) == [23]
    assert SS.new |> S.push(23) |> S.push(42) |> S.foldr([], [&1 | &2]) == [42, 23]
    assert SS.new |> S.push(23) |> S.push(42) |> S.push(1337) |> S.foldr([], [&1 | &2]) == [1337, 42, 23]
  end

  test :to_list do
    assert SS.new(1 .. 3) |> S.to_list == [1, 2, 3]
    assert SS.new |> S.push(23) |> S.to_list == [23]
    assert SS.new |> S.push(23) |> S.push(42) |> S.to_list == [42, 23]
    assert SS.new |> S.push(23) |> S.push(42) |> S.push(1337) |> S.to_list == [1337, 42, 23]
  end

  test :inspect do
    assert SS.new |> inspect == "#Stack<[]>"
    assert SS.new |> S.push(23) |> inspect == "#Stack<[23]>"
    assert SS.new |> S.push(23) |> S.push(42) |> inspect == "#Stack<[42,23]>"
    assert SS.new |> S.push(23) |> S.push(42) |> S.push(1337) |> inspect == "#Stack<[1337,42,23]>"
  end

#  doctest Data.Stack.Simple
end

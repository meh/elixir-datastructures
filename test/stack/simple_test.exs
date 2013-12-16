Code.require_file "../test_helper.exs", __DIR__

defmodule StackSimpleTest do
  use ExUnit.Case, async: true
  alias Data.Stack
  alias Data.Stack.Simple

  test :push do
    assert Simple.new |> Stack.push(42) |> Data.to_list == [42]
    assert Simple.new |> Stack.push(42) |> Stack.push(23) |> Data.to_list == [23, 42]
  end

  test :pop do
    assert { 23, _ } = Simple.new |> Stack.push(23) |> Stack.pop
    assert { 42, _ } = Simple.new |> Stack.pop(42)
  end

  test :pop! do
    assert { 23, _ } = Simple.new |> Stack.push(23) |> Stack.pop!

    assert_raise Data.Empty, fn ->
      Simple.new |> Stack.pop!
    end
  end

  test :peek do
    assert Simple.new |> Stack.push(23) |> Data.peek == 23
    assert Simple.new |> Data.peek(42) == 42
  end

  test :peek! do
    assert Simple.new |> Stack.push(23) |> Data.peek! == 23

    assert_raise Data.Empty, fn ->
      Simple.new |> Data.peek!
    end
  end

  test :first do
    assert Simple.new |> Data.Seq.first == nil
    assert Simple.new |> Stack.push(42) |> Data.Seq.first == 42
  end

  test :next do
    assert Simple.new |> Data.Seq.next == nil
    assert Simple.new |> Stack.push(42) |> Data.Seq.next == nil
    assert Simple.new |> Stack.push(42) |> Stack.push(23) |> Data.Seq.next |> Data.to_list == [42]
  end

  test :reverse do
    assert Simple.new |> Data.reverse |> Data.to_list == []
    assert Simple.new |> Stack.push(23) |> Stack.push(42) |> Data.reverse |> Data.to_list == [23, 42]
  end

  test :empty? do
    assert Simple.new |> Data.empty?
    refute Simple.new |> Stack.push(23) |> Data.empty?
  end

  test :clear do
    assert Simple.new |> Stack.push(23) |> Data.clear |> Data.empty?
  end

  test :to_list do
    assert Simple.new |> Stack.push(23) |> Stack.push(42) |> Data.to_list == [42, 23]
  end

  test :contains? do
    refute Simple.new |> Data.contains?(23)
    assert Simple.new |> Stack.push(42) |> Data.contains?(42)
  end

  test Enumerable do
    assert Simple.new |> Stack.push(23) |> Stack.push(42) |> Enum.to_list == [42, 23]
  end
end

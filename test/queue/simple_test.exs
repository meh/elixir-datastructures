Code.require_file "../test_helper.exs", __DIR__

defmodule Test.Queue.Simple do
  use ExUnit.Case, async: true
  alias Data.Queue
  alias Data.Queue.Simple

  test :enq do
    assert Simple.new |> Queue.enq(42) |> Data.to_list == [42]
    assert Simple.new |> Queue.enq(42) |> Queue.enq(23) |> Data.to_list == [42, 23]
  end

  test :deq do
    assert { 23, _ } = Simple.new |> Queue.enq(23) |> Queue.deq
    assert { 42, _ } = Simple.new |> Queue.deq(42)
  end

  test :deq! do
    assert { 23, _ } = Simple.new |> Queue.enq(23) |> Queue.deq!

    assert_raise Data.Error.Empty, fn ->
      Simple.new |> Queue.deq!
    end
  end

  test :peek do
    assert Simple.new |> Queue.enq(23) |> Data.peek == 23
    assert Simple.new |> Data.peek(42) == 42
  end

  test :peek! do
    assert Simple.new |> Queue.enq(23) |> Data.peek! == 23

    assert_raise Data.Error.Empty, fn ->
      Simple.new |> Data.peek!
    end
  end

  test :first do
    assert Simple.new |> Data.Seq.first == nil
    assert Simple.new |> Queue.enq(42) |> Data.Seq.first == 42
  end

  test :next do
    assert Simple.new |> Data.Seq.next == nil
    assert Simple.new |> Queue.enq(42) |> Data.Seq.next == nil
    assert Simple.new |> Queue.enq(42) |> Queue.enq(23) |> Data.Seq.next |> Data.to_list == [23]
  end

  test :reverse do
    assert Simple.new |> Data.reverse |> Data.to_list == []
    assert Simple.new |> Queue.enq(23) |> Queue.enq(42) |> Data.reverse |> Data.to_list == [42, 23]
  end

  test :empty? do
    assert Simple.new |> Data.empty?
    refute Simple.new |> Queue.enq(23) |> Data.empty?
  end

  test :clear do
    assert Simple.new |> Queue.enq(23) |> Data.clear |> Data.empty?
  end

  test :to_list do
    assert Simple.new |> Queue.enq(23) |> Queue.enq(42) |> Data.to_list == [23, 42]
  end

  test :contains? do
    refute Simple.new |> Data.contains?(23)
    assert Simple.new |> Queue.enq(42) |> Data.contains?(42)
  end

  test Enumerable do
    assert Simple.new |> Queue.enq(23) |> Queue.enq(42) |> Enum.to_list == [23, 42]
  end
end

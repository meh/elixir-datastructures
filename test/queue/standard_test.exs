Code.require_file "../test_helper.exs", __DIR__

defmodule Test.Queue.Standard do
  use ExUnit.Case, async: true
  alias Data.Queue
  alias Data.Queue.Standard

  test :enq do
    assert Standard.new |> Queue.enq(42) |> Data.to_list == [42]
    assert Standard.new |> Queue.enq(42) |> Queue.enq(23) |> Data.to_list == [42, 23]
  end

  test :deq do
    assert { 23, _ } = Standard.new |> Queue.enq(23) |> Queue.deq
    assert { 42, _ } = Standard.new |> Queue.deq(42)
  end

  test :deq! do
    assert { 23, _ } = Standard.new |> Queue.enq(23) |> Queue.deq!

    assert_raise Data.Empty, fn ->
      Standard.new |> Queue.deq!
    end
  end

  test :peek do
    assert Standard.new |> Queue.enq(23) |> Data.peek == 23
    assert Standard.new |> Data.peek(42) == 42
  end

  test :peek! do
    assert Standard.new |> Queue.enq(23) |> Data.peek! == 23

    assert_raise Data.Empty, fn ->
      Standard.new |> Data.peek!
    end
  end

  test :first do
    assert Standard.new |> Data.Seq.first == nil
    assert Standard.new |> Queue.enq(42) |> Data.Seq.first == 42
  end

  test :next do
    assert Standard.new |> Data.Seq.next == nil
    assert Standard.new |> Queue.enq(42) |> Data.Seq.next == nil
    assert Standard.new |> Queue.enq(42) |> Queue.enq(23) |> Data.Seq.next |> Data.to_list == [23]
  end

  test :reverse do
    assert Standard.new |> Data.reverse |> Data.to_list == []
    assert Standard.new |> Queue.enq(23) |> Queue.enq(42) |> Data.reverse |> Data.to_list == [42, 23]
  end

  test :empty? do
    assert Standard.new |> Data.empty?
    refute Standard.new |> Queue.enq(23) |> Data.empty?
  end

  test :clear do
    assert Standard.new |> Queue.enq(23) |> Data.clear |> Data.empty?
  end

  test :to_list do
    assert Standard.new |> Queue.enq(23) |> Queue.enq(42) |> Data.to_list == [23, 42]
  end

  test :contains? do
    refute Standard.new |> Data.contains?(23)
    assert Standard.new |> Queue.enq(42) |> Data.contains?(42)
  end

  test Enumerable do
    assert Standard.new |> Queue.enq(23) |> Queue.enq(42) |> Enum.to_list == [23, 42]
  end
end

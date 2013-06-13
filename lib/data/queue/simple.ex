#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Queue.Simple do
  @moduledoc """
  A simple and performant queue.
  """

  @opaque t :: record
  @type   v :: any

  defrecordp :queue, enqueue: [], dequeue: []

  @doc """
  Creates an empty queue.
  """
  @spec new :: t
  def new do
    queue()
  end

  @doc """
  Creates a new queue from the given enumerable.

  ## Examples

      iex> Data.Queue.Simple.new(1 .. 4)
      #Queue<[1,2,3,4]>

  """
  @spec new(Enum.t) :: t
  def new(enum) do
    queue(dequeue: Data.to_list(enum))
  end

  @doc """
  Enqueue a value in the queue.

  ## Examples

      iex> Data.Queue.Simple.new |> Data.Queue.enq(42) |> Data.Queue.enq(23) |> Data.Queue.enq(1337)
      #Queue<[42,23,1337]>

  """
  @spec enq(t, v) :: t
  def enq(queue(enqueue: [], dequeue: []), value) do
    queue(dequeue: [value])
  end

  # minor amortization in case of two enqs
  def enq(queue(enqueue: enq, dequeue: [deq]), value) do
    queue(enqueue: enq, dequeue: [deq, value])
  end

  def enq(queue(enqueue: enq, dequeue: deq), value) do
    queue(enqueue: [value | enq], dequeue: deq)
  end

  @doc """
  Dequeue a value from the queue.

  ## Examples

      iex> Data.Queue.Simple.new |> Data.Queue.enq(42) |> Data.Queue.enq(23) |> Data.Queue.deq
      {42,#Queue<[23]>}
      iex> Data.Queue.Simple.new |> Data.Queue.deq(:empty)
      {:empty,#Queue<[]>}

  """
  @spec deq(t)    :: { v, t }
  @spec deq(t, v) :: { v, t }
  def deq(queue, default // nil)

  def deq(queue(enqueue: [], dequeue: []), default) do
    { default, queue() }
  end

  def deq(queue(enqueue: [], dequeue: [deq]), _) do
    { deq, queue() }
  end

  def deq(queue(enqueue: [enq], dequeue: [deq]), _) do
    { deq, queue(dequeue: [enq]) }
  end

  def deq(queue(enqueue: enq, dequeue: [value]), _) do
    { value, queue(dequeue: Enum.reverse(enq)) }
  end

  def deq(queue(enqueue: enq, dequeue: [head | rest]), _) do
    { head, queue(enqueue: enq, dequeue: rest) }
  end

  @doc """
  Dequeue a value from the queue, raising if its empty.

  ## Examples

      iex> Data.Queue.Simple.new |> Data.Queue.enq(42) |> Data.Queue.deq!
      {42,#Queue<[]>}
      iex> Data.Queue.Simple.new |> Data.Queue.deq!
      ** (Data.Empty) the queue is empty

  """
  @spec deq!(t) :: { v, t } | no_return
  def deq!(queue(enqueue: [], dequeue: [])) do
    raise Data.Empty
  end

  def deq!(queue) do
    deq(queue)
  end

  @doc """
  Peek the element that would be dequeued.

  ## Examples

      iex> Data.Queue.Simple.new |> Data.Queue.enq(42) |> Data.Queue.peek
      42
      iex> Data.Queue.Simple.new |> Data.Queue.peek(:empty)
      :empty

  """
  @spec peek(t)    :: v
  @spec peek(t, v) :: v
  def peek(queue, default // nil)

  def peek(queue(enqueue: [], dequeue: []), default) do
    default
  end

  def peek(queue(dequeue: [value | _]), _) do
    value
  end

  @doc """
  Peek the element that should be dequeued, raising if it's empty.

  ## Examples

      iex> Data.Queue.Simple.new |> Data.Queue.enq(42) |> Data.Queue.enq(23) |> Data.Queue.peek!
      42
      iex> Data.Queue.Simple.new |> Data.Queue.peek!
      ** (Data.Empty) the queue is empty

  """
  @spec peek!(t) :: v | no_return
  def peek!(queue(enqueue: [], dequeue: [])) do
    raise Data.Empty
  end

  def peek!(queue) do
    peek(queue)
  end

  @doc """
  Reverse the queue.

  ## Examples

      iex> Data.Queue.Simple.new(1 .. 4) |> Data.Queue.reverse
      #Queue<[4,3,2,1]>

  """
  @spec reverse(t) :: t
  def reverse(queue(enqueue: enq, dequeue: deq)) do
    queue(enqueue: deq, dequeue: enq)
  end

  @doc """
  Check if the queue is empty.
  """
  @spec empty?(t) :: boolean
  def empty?(queue(enqueue: [], dequeue: [])) do
    true
  end

  def empty?(queue()) do
    false
  end

  @spec clear(t) :: t
  def clear(_) do
    queue()
  end

  @doc """
  Check if the the value is present in the queue.
  """
  @spec member?(t, v) :: boolean
  def member?(queue(enqueue: [], dequeue: [])) do
    false
  end

  def member?(queue(enqueue: enq, dequeue: deq), value) do
    Enum.member?(enq, value) or Enum.member?(deq, value)
  end

  @doc """
  Get the size of the queue.
  """
  @spec size(t) :: non_neg_integer
  def size(queue(enqueue: enq, dequeue: deq)) do
    length(enq) + length(deq)
  end

  @doc """
  Fold the queue from the left.
  """
  @spec foldl(t, any, ((v, any) -> any)) :: any
  def foldl(queue(enqueue: enq, dequeue: deq), acc, fun) do
    List.foldr(enq, List.foldl(deq, acc, fun), fun)
  end

  @doc """
  Fold the queue from the right.
  """
  @spec foldr(t, any, ((v, any) -> any)) :: any
  def foldr(queue(enqueue: enq, dequeue: deq), acc, fun) do
    List.foldr(deq, List.foldl(enq, acc, fun), fun)
  end

  @doc """
  Convert the queue to a list.
  """
  @spec to_list(t) :: [v]
  def to_list(queue(enqueue: enq, dequeue: deq)) do
    deq ++ Enum.reverse(enq)
  end
end

defimpl Data.Queue, for: Data.Queue.Simple do
  defdelegate enq(self, value), to: Data.Queue.Simple
  defdelegate deq(self), to: Data.Queue.Simple
  defdelegate deq(self, default), to: Data.Queue.Simple
  defdelegate deq!(self), to: Data.Queue.Simple
end

defimpl Data.Peekable, for: Data.Queue.Simple do
  defdelegate peek(self), to: Data.Queue.Simple
  defdelegate peek(self, default), to: Data.Queue.Simple
  defdelegate peek!(self), to: Data.Queue.Simple
end

defimpl Data.Sequence, for: Data.Queue.Simple do
  def first(self) do
    Data.Queue.Simple.peek(self)
  end

  def next(self) do
    if Data.Queue.Simple.size(self) > 1 do
      { _, next } = Data.Queue.Simple.deq(self)

      next
    end
  end
end

defimpl Data.Reversible, for: Data.Queue.Simple do
  defdelegate reverse(self), to: Data.Queue.Simple
end

defimpl Data.Emptyable, for: Data.Queue.Simple do
  defdelegate empty?(self), to: Data.Queue.Simple
  defdelegate clear(self), to: Data.Queue.Simple
end

defimpl Data.Foldable, for: Data.Queue.Simple do
  defdelegate foldl(self, acc, fun), to: Data.Queue.Simple
  defdelegate foldr(self, acc, fun), to: Data.Queue.Simple
end

defimpl Data.Listable, for: Data.Queue.Simple do
  defdelegate to_list(self), to: Data.Queue.Simple
end

defimpl Data.Contains, for: Data.Queue.Simple do
  defdelegate contains?(self, value), to: Data.Queue.Simple, as: :member?
end

defimpl Enumerable, for: Data.Queue.Simple do
  defdelegate reduce(self, acc, fun), to: Data.Queue.Simple, as: :foldl
  defdelegate count(self), to: Data.Queue.Simple, as: :size
  defdelegate member?(self, value), to: Data.Queue.Simple
end

defimpl Binary.Inspect, for: Data.Queue.Simple do
  def inspect(queue, opts) do
    "#Queue<" <> Kernel.inspect(Data.Queue.Simple.to_list(queue), opts) <> ">"
  end
end

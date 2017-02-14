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

  alias Data.Protocol, as: P
  alias __MODULE__, as: T

  defstruct enqueue: [], dequeue: []

  @opaque t :: __MODULE__.t
  @type   v :: any

  @doc """
  Creates an empty queue.
  """
  @spec new :: t
  def new do
    %T{}
  end

  @doc """
  Creates a new queue from the given enumerable.

  ## Examples

      iex> T.new(1 .. 4)
      #Queue<[1,2,3,4]>

  """
  @spec new(Enum.t) :: t
  def new(enum) do
    %T{dequeue: Data.list(enum)}
  end

  @doc """
  Enqueue a value in the queue.

  ## Examples

      iex> T.new |> Data.Queue.enq(42) |> Data.Queue.enq(23) |> Data.Queue.enq(1337)
      #Queue<[42,23,1337]>

  """
  @spec enq(t, v) :: t
  def enq(%T{enqueue: [], dequeue: []}, value) do
    %T{dequeue: [value]}
  end

  # minor amortization in case of two enqs
  def enq(%T{enqueue: enq, dequeue: [deq]}, value) do
    %T{enqueue: enq, dequeue: [deq, value]}
  end

  def enq(%T{enqueue: enq, dequeue: deq}, value) do
    %T{enqueue: [value | enq], dequeue: deq}
  end

  @doc """
  Dequeue a value from the queue.

  ## Examples

      iex> T.new |> Data.Queue.enq(42) |> Data.Queue.enq(23) |> Data.Queue.deq
      {42,#Queue<[23]>}
      iex> T.new |> Data.Queue.deq(:empty)
      {:empty,#Queue<[]>}

  """
  @spec deq(t) :: { :empty | { :value, v }, t }
  def deq(%T{enqueue: [], dequeue: []}) do
    { :empty, %T{} }
  end

  def deq(%T{enqueue: [], dequeue: [deq]}) do
    { { :value, deq }, %T{} }
  end

  def deq(%T{enqueue: [enq], dequeue: [deq]}) do
    { { :value, deq }, %T{dequeue: [enq]} }
  end

  def deq(%T{enqueue: enq, dequeue: [value]}) do
    { { :value, value }, %T{dequeue: Enum.reverse(enq)} }
  end

  def deq(%T{enqueue: enq, dequeue: [head | rest]}) do
    { { :value, head }, %T{enqueue: enq, dequeue: rest} }
  end

  @doc """
  Peek the element that would be dequeued.

  ## Examples

      iex> T.new |> Data.Queue.enq(42) |> Data.Queue.peek
      42
      iex> T.new |> Data.Queue.peek(:empty)
      :empty

  """
  @spec peek(t) :: { :ok, any } | :error
  def peek(%T{enqueue: [], dequeue: []}) do
    :empty
  end

  def peek(%T{dequeue: [value | _]}) do
    { :value, value }
  end

  @doc """
  Reverse the queue.

  ## Examples

      iex> T.new(1 .. 4) |> Data.Queue.reverse
      #Queue<[4,3,2,1]>

  """
  @spec reverse(t) :: t
  def reverse(%T{enqueue: enq, dequeue: deq}) do
    %T{enqueue: deq, dequeue: enq}
  end

  @doc """
  Check if the queue is empty.
  """
  @spec empty?(t) :: boolean
  def empty?(%T{enqueue: [], dequeue: []}) do
    true
  end

  def empty?(%T{}) do
    false
  end

  @spec clear(t) :: t
  def clear(_) do
    %T{}
  end

  @doc """
  Check if the the value is present in the queue.
  """
  @spec member?(t, v) :: boolean
  def member?(%T{enqueue: [], dequeue: []}) do
    false
  end

  def member?(%T{enqueue: enq, dequeue: deq}, value) do
    Enum.member?(enq, value) or Enum.member?(deq, value)
  end

  @doc """
  Get the size of the queue.
  """
  @spec size(t) :: non_neg_integer
  def size(%T{enqueue: enq, dequeue: deq}) do
    length(enq) + length(deq)
  end

  @doc """
  Fold the queue from the left.
  """
  @spec foldl(t, any, ((v, any) -> any)) :: any
  def foldl(%T{enqueue: enq, dequeue: deq}, acc, fun) do
    List.foldr(enq, List.foldl(deq, acc, fun), fun)
  end

  @doc """
  Fold the queue from the right.
  """
  @spec foldr(t, any, ((v, any) -> any)) :: any
  def foldr(%T{enqueue: enq, dequeue: deq}, acc, fun) do
    List.foldr(deq, List.foldl(enq, acc, fun), fun)
  end

  @doc """
  Convert the queue to a list.
  """
  @spec to_list(t) :: [v]
  def to_list(%T{enqueue: enq, dequeue: deq}) do
    deq ++ Enum.reverse(enq)
  end

  defimpl P.Queue do
    defdelegate enq(self, value), to: T
    defdelegate deq(self), to: T
  end

  defimpl P.Peek do
    defdelegate peek(self), to: T
  end

  defimpl P.Sequence do
    def first(self) do
      Data.peek(self)
    end

    def next(self) do
      if T.size(self) > 1 do
        { _, next } = T.deq(self)

        next
      end
    end
  end

  defimpl P.Reverse do
    defdelegate reverse(self), to: T
  end

  defimpl P.Empty do
    defdelegate empty?(self), to: T
    defdelegate clear(self), to: T
  end

  defimpl P.Reduce do
    defdelegate reduce(self, acc, fun), to: T, as: :foldl
  end

  defimpl P.ToList do
    defdelegate to_list(self), to: T
  end

  defimpl P.Contains do
    defdelegate contains?(self, value), to: T, as: :member?
  end

  defimpl P.Into do
    def into(self, value) do
      self |> T.enq(value)
    end
  end

  defimpl Enumerable do
    use Data.Enumerable
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(queue, opts) do
      concat ["#Queue<", to_doc(T.to_list(queue), opts), ">"]
    end
  end
end

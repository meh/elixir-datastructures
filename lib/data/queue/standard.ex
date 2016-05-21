#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Queue.Standard do
  alias Data.Protocol, as: P
  alias __MODULE__, as: T

  defstruct [:queue]

  def new do
    %T{queue: :queue.new}
  end

  def new(enum_or_queue) do
    if :queue.is_queue(enum_or_queue) do
      %T{queue: enum_or_queue}
    else
      %T{queue: Data.to_list(enum_or_queue) |> :queue.from_list}
    end
  end

  def enq(%T{queue: queue}, value) do
    %T{queue: :queue.in(value, queue)}
  end

  def reverse_enq(%T{queue: queue}, value) do
    %T{queue: :queue.in_r(value, queue)}
  end

  def deq(%T{queue: queue}) do
    case :queue.out(queue) do
      { :empty, queue } ->
        { :empty, %T{queue: queue} }

      { value, queue } ->
        { value, %T{queue: queue} }
    end
  end

  def reverse_deq(%T{queue: queue}) do
    case :queue.out_r(queue) do
      { :empty, queue } ->
        { :empty, %T{queue: queue} }

      { value, queue } ->
        { value, %T{queue: queue} }
    end
  end

  def peek(%T{queue: queue}) do
    :queue.peek(queue)
  end

  def reverse_peek(%T{queue: queue}) do
    :queue.peek_r(queue)
  end

  def reverse(%T{queue: queue}) do
    %T{queue: :queue.reverse(queue)}
  end

  def empty?(%T{queue: queue}) do
    :queue.is_empty(queue)
  end

  def clear(_) do
    new
  end

  def member?(%T{queue: queue}, value) do
    :queue.member(value, queue)
  end

  def size(%T{queue: queue}) do
    :queue.len(queue)
  end

  def foldl(%T{queue: queue}, acc, fun) do
    List.foldl(:queue.to_list(queue), acc, fun)
  end

  def foldr(%T{queue: queue}, acc, fun) do
    List.foldr(:queue.to_list(queue), acc, fun)
  end

  def to_list(%T{queue: queue}) do
    :queue.to_list(queue)
  end

  defimpl P.Queue do
    defdelegate enq(self, value), to: T
    defdelegate deq(self), to: T
  end

  defimpl P.Count do
    defdelegate count(self), to: T, as: :size
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

  defimpl P.Stack do
    defdelegate push(self, value), to: T, as: :reverse_enq
    defdelegate pop(self), to: T, as: :reverse_deq
  end

  defimpl P.Contains do
    defdelegate contains?(self, key), to: T, as: :member?
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

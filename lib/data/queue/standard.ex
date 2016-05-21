#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Queue.Standard do
  alias Data.Protocol, as: P

  defstruct [:queue]

  def new do
    %__MODULE__{queue: :queue.new}
  end

  def new(enum_or_queue) do
    if :queue.is_queue(enum_or_queue) do
      %__MODULE__{queue: enum_or_queue}
    else
      %__MODULE__{queue: Data.to_list(enum_or_queue) |> :queue.from_list}
    end
  end

  def enq(%__MODULE__{queue: queue}, value) do
    %__MODULE__{queue: :queue.in(value, queue)}
  end

  def reverse_enq(%__MODULE__{queue: queue}, value) do
    %__MODULE__{queue: :queue.in_r(value, queue)}
  end

  def deq(%__MODULE__{queue: queue}) do
    case :queue.out(queue) do
      { :empty, queue } ->
        { :empty, %__MODULE__{queue: queue} }

      { value, queue } ->
        { value, %__MODULE__{queue: queue} }
    end
  end

  def reverse_deq(%__MODULE__{queue: queue}) do
    case :queue.out_r(queue) do
      { :empty, queue } ->
        { :empty, %__MODULE__{queue: queue} }

      { value, queue } ->
        { value, %__MODULE__{queue: queue} }
    end
  end

  def peek(%__MODULE__{queue: queue}) do
    :queue.peek(queue)
  end

  def reverse_peek(%__MODULE__{queue: queue}) do
    :queue.peek_r(queue)
  end

  def reverse(%__MODULE__{queue: queue}) do
    %__MODULE__{queue: :queue.reverse(queue)}
  end

  def empty?(%__MODULE__{queue: queue}) do
    :queue.is_empty(queue)
  end

  def clear(_) do
    new
  end

  def member?(%__MODULE__{queue: queue}, value) do
    :queue.member(value, queue)
  end

  def size(%__MODULE__{queue: queue}) do
    :queue.len(queue)
  end

  def foldl(%__MODULE__{queue: queue}, acc, fun) do
    List.foldl(:queue.to_list(queue), acc, fun)
  end

  def foldr(%__MODULE__{queue: queue}, acc, fun) do
    List.foldr(:queue.to_list(queue), acc, fun)
  end

  def to_list(%__MODULE__{queue: queue}) do
    :queue.to_list(queue)
  end

  defimpl P.Queue do
    defdelegate enq(self, value), to: Data.Queue.Standard
    defdelegate deq(self), to: Data.Queue.Standard
  end

  defimpl P.Count do
    defdelegate count(self), to: Data.Queue.Standard, as: :size
  end

  defimpl P.Peek do
    defdelegate peek(self), to: Data.Queue.Standard
  end

  defimpl P.Sequence do
    def first(self) do
      Data.peek(self)
    end

    def next(self) do
      if Data.Queue.Standard.size(self) > 1 do
        { _, next } = Data.Queue.Standard.deq(self)

        next
      end
    end
  end

  defimpl P.Reverse do
    defdelegate reverse(self), to: Data.Queue.Standard
  end

  defimpl P.Empty do
    defdelegate empty?(self), to: Data.Queue.Standard
    defdelegate clear(self), to: Data.Queue.Standard
  end

  defimpl P.Reduce do
    defdelegate reduce(self, acc, fun), to: Data.Queue.Standard, as: :foldl
  end

  defimpl P.ToList do
    defdelegate to_list(self), to: Data.Queue.Standard
  end

  defimpl P.Stack do
    defdelegate push(self, value), to: Data.Queue.Standard, as: :reverse_enq
    defdelegate pop(self), to: Data.Queue.Standard, as: :reverse_deq
  end

  defimpl P.Contains do
    defdelegate contains?(self, key), to: Data.Queue.Standard, as: :member?
  end

  defimpl Enumerable do
    use Data.Enumerable
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(queue, opts) do
      concat ["#Queue<", Kernel.inspect(Data.Queue.Standard.to_list(queue), opts), ">"]
    end
  end
end

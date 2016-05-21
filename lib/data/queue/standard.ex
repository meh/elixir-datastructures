#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Queue.Standard do
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

  def deq(%__MODULE__{queue: queue}, default \\ nil) do
    case :queue.out(queue) do
      { :empty, queue } ->
        { default, %__MODULE__{queue: queue} }

      { { :value, value }, queue } ->
        { value, %__MODULE__{queue: queue} }
    end
  end

  def deq!(%__MODULE__{queue: queue}) do
    case :queue.out(queue) do
      { :empty, _ } ->
        raise Data.Error.Empty

      { { :value, value }, queue } ->
        { value, %__MODULE__{queue: queue} }
    end
  end

  def reverse_deq(%__MODULE__{queue: queue}, default \\ nil) do
    case :queue.out_r(queue) do
      { :empty, queue } ->
        { default, %__MODULE__{queue: queue} }

      { { :value, value }, queue } ->
        { value, %__MODULE__{queue: queue} }
    end
  end

  def reverse_deq!(%__MODULE__{queue: queue}) do
    case :queue.out_r(queue) do
      { :empty, _ } ->
        raise Data.Error.Empty

      { { :value, value }, queue } ->
        { value, %__MODULE__{queue: queue} }
    end
  end

  def peek(%__MODULE__{queue: queue}, default \\ nil) do
    case :queue.peek(queue) do
      :empty ->
        default

      { :value, value } ->
        value
    end
  end

  def peek!(%__MODULE__{queue: queue}) do
    case :queue.peek(queue) do
      :empty ->
        raise Data.Error.Empty

      { :value, value } ->
        value
    end
  end

  def reverse_peek(%__MODULE__{queue: queue}, default \\ nil) do
    case :queue.peek_r(queue) do
      :empty ->
        default

      { :value, value } ->
        value
    end
  end

  def reverse_peek!(%__MODULE__{queue: queue}) do
    case :queue.peek_r(queue) do
      :empty ->
        raise Data.Error.Empty

      { :value, value } ->
        value
    end
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
end

defimpl Data.Queue, for: Data.Queue.Standard do
  defdelegate enq(self, value), to: Data.Queue.Standard
  defdelegate deq(self), to: Data.Queue.Standard
  defdelegate deq(self, default), to: Data.Queue.Standard
  defdelegate deq!(self), to: Data.Queue.Standard
end

defimpl Data.Counted, for: Data.Queue.Standard do
  defdelegate count(self), to: Data.Queue.Standard, as: :size
end

defimpl Data.Peekable, for: Data.Queue.Standard do
  defdelegate peek(self), to: Data.Queue.Standard
  defdelegate peek(self, default), to: Data.Queue.Standard
  defdelegate peek!(self), to: Data.Queue.Standard
end

defimpl Data.Sequence, for: Data.Queue.Standard do
  def first(self) do
    Data.Queue.Standard.peek(self)
  end

  def next(self) do
    if Data.Queue.Standard.size(self) > 1 do
      { _, next } = Data.Queue.Standard.deq(self)

      next
    end
  end
end

defimpl Data.Reversible, for: Data.Queue.Standard do
  defdelegate reverse(self), to: Data.Queue.Standard
end

defimpl Data.Emptyable, for: Data.Queue.Standard do
  defdelegate empty?(self), to: Data.Queue.Standard
  defdelegate clear(self), to: Data.Queue.Standard
end

defimpl Data.Reducible, for: Data.Queue.Standard do
  defdelegate reduce(self, acc, fun), to: Data.Queue.Standard, as: :foldl
end

defimpl Data.Listable, for: Data.Queue.Standard do
  defdelegate to_list(self), to: Data.Queue.Standard
end

defimpl Data.Stack, for: Data.Queue.Standard do
  defdelegate push(self, value), to: Data.Queue.Standard, as: :reverse_enq
  defdelegate pop(self), to: Data.Queue.Standard, as: :reverse_deq
  defdelegate pop(self, default), to: Data.Queue.Standard, as: :reverse_deq
  defdelegate pop!(self), to: Data.Queue.Standard, as: :reverse_deq!
end

defimpl Data.Contains, for: Data.Queue.Standard do
  defdelegate contains?(self, key), to: Data.Queue.Standard, as: :member?
end

defimpl Enumerable, for: Data.Queue.Standard do
  use Data.Enumerable
end

defimpl Inspect, for: Data.Queue.Standard do
  import Inspect.Algebra

  def inspect(queue, opts) do
    concat ["#Queue<", Kernel.inspect(Data.Queue.Standard.to_list(queue), opts), ">"]
  end
end

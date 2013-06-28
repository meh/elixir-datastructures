#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Queue.Standard do
  defrecordp :wrap, queue: nil

  def new do
    wrap(queue: :queue.new)
  end

  def new(enum_or_queue) do
    if :queue.is_queue(enum_or_queue) do
      wrap(queue: enum_or_queue)
    else
      wrap(queue: Data.to_list(enum_or_queue) |> :queue.from_list)
    end
  end

  def enq(wrap(queue: queue), value) do
    wrap(queue: :queue.in(value, queue))
  end

  def reverse_enq(wrap(queue: queue), value) do
    wrap(queue: :queue.in_r(value, queue))
  end

  def deq(wrap(queue: queue), default // nil) do
    case :queue.out(queue) do
      { :empty, queue } ->
        { default, wrap(queue: queue) }

      { { :value, value }, queue } ->
        { value, wrap(queue: queue) }
    end
  end

  def deq!(wrap(queue: queue)) do
    case :queue.out(queue) do
      { :empty, _ } ->
        raise Data.Empty

      { { :value, value }, queue } ->
        { value, wrap(queue: queue) }
    end
  end

  def reverse_deq(wrap(queue: queue), default // nil) do
    case :queue.out_r(queue) do
      { :empty, queue } ->
        { default, wrap(queue: queue) }

      { { :value, value }, queue } ->
        { value, wrap(queue: queue) }
    end
  end

  def reverse_deq!(wrap(queue: queue)) do
    case :queue.out_r(queue) do
      { :empty, _ } ->
        raise Data.Empty

      { { :value, value }, queue } ->
        { value, wrap(queue: queue) }
    end
  end

  def peek(wrap(queue: queue), default // nil) do
    case :queue.peek(queue) do
      :empty ->
        default

      { :value, value } ->
        value
    end
  end

  def peek!(wrap(queue: queue)) do
    case :queue.peek(queue) do
      :empty ->
        raise Data.Empty

      { :value, value } ->
        value
    end
  end

  def reverse_peek(wrap(queue: queue), default // nil) do
    case :queue.peek_r(queue) do
      :empty ->
        default

      { :value, value } ->
        value
    end
  end

  def reverse_peek!(wrap(queue: queue)) do
    case :queue.peek_r(queue) do
      :empty ->
        raise Data.Empty

      { :value, value } ->
        value
    end
  end

  def reverse(wrap(queue: queue)) do
    wrap(queue: :queue.reverse(queue))
  end

  def empty?(wrap(queue: queue)) do
    :queue.is_empty(queue)
  end

  def member?(wrap(queue: queue), value) do
    :queue.member(value, queue)
  end

  def size(wrap(queue: queue)) do
    :queue.len(queue)
  end

  def foldl(wrap(queue: queue), acc, fun) do
    List.foldl(:queue.to_list(queue), acc, fun)
  end

  def foldr(wrap(queue: queue), acc, fun) do
    List.foldr(:queue.to_list(queue), acc, fun)
  end

  def to_list(wrap(queue: queue)) do
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

defimpl Binary.Inspect, for: Data.Queue.Standard do
  def inspect(queue, opts) do
    "#Queue<" <> Kernel.inspect(Data.Queue.Standard.to_list(queue), opts) <> ">"
  end
end

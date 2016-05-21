#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Stack.Simple do
  @moduledoc """
  A simple stack.
  """

  defstruct list: []

  @opaque t :: __MODULE__.t
  @type   v :: any

  @doc """
  Creates an empty stack.
  """
  @spec new :: t
  def new do
    %__MODULE__{}
  end

  @doc """
  Creates a new stack from the given enumerable.

  ## Examples

      iex> Data.Stack.Simple.new(1 .. 4)
      #Stack<[1,2,3,4]>

  """
  @spec new(Enum.t) :: t
  def new(enum) do
    %__MODULE__{list: Data.to_list(enum)}
  end

  @doc """
  Push a value in the stack.

  ## Examples

      iex> Data.Stack.Simple.new |> Stack.push(42) |> Stack.push(23) |> Stack.push(1337)
      #Stack<[1337,23,42]>

  """
  @spec push(t, v) :: t
  def push(%__MODULE__{list: list}, value) do
    %__MODULE__{list: [value | list]}
  end

  @doc """
  Pop a value from the stack.

  ## Examples

      iex> Data.Stack.Simple.new |> Stack.push(42) |> Stack.push(23) |> Stack.pop
      {23,#Stack<[42]>}
      iex> Data.Stack.Simple.new |> Stack.pop(:empty)
      {:empty,#Stack<[]>}

  """
  @spec pop(t)    :: { v, t }
  @spec pop(t, v) :: { v, t }
  def pop(stack, default \\ nil)

  def pop(%__MODULE__{list: []}, default) do
    { default, %__MODULE__{} }
  end

  def pop(%__MODULE__{list: [head | rest]}, _) do
    { head, %__MODULE__{list: rest} }
  end

  @doc """
  Pop a value from the stack, raising if it's empty.

  ## Examples

      iex> Data.Stack.Simple.new |> Stack.push(42) |> Stack.pop
      {42,#Stack<[]>}
      iex> Data.Stack.Simple.new |> Stack.pop!
      ** (Data.Error.Empty) the queue is empty

  """
  @spec pop!(t) :: { v, t } | no_return
  def pop!(%__MODULE__{list: []}) do
    raise Data.Error.Empty
  end

  def pop!(%__MODULE__{} = self) do
    pop(self)
  end

  @doc """
  Peek the element that would be popped.

  ## Examples

      iex> Data.Stack.Simple.new |> Stack.push(42) |> Stack.peek
      42
      iex> Data.Stack.Simple.new |> Stack.peek(:empty)
      :empty

  """
  @spec peek(t)    :: v
  @spec peek(t, v) :: v
  def peek(stack, default \\ nil)

  def peek(%__MODULE__{list: []}, default) do
    default
  end

  def peek(%__MODULE__{list: [head | _]}, _) do
    head
  end

  @doc """
  Peek the element that should be popped, raising if it's empty.

  ## Examples

      iex> Data.Stack.Simple.new |> Stack.push(42) |> Stack.push(23) |> Stack.peek!
      23
      iex> Data.Stack.Simple.new |> Stack.peek!
      ** (Data.Error.Empty) the stack is empty

  """
  @spec peek!(t) :: v | no_return
  def peek!(%__MODULE__{list: []}) do
    raise Data.Error.Empty
  end

  def peek!(stack) do
    peek(stack)
  end

  @doc """
  Reverse the stack.

  ## Examples

      iex> Data.Stack.Simple.new(1 .. 4) |> Stack.reverse
      #Stack<[4,3,2,1]>

  """
  @spec reverse(t) :: t
  def reverse(%__MODULE__{list: list}) do
    %__MODULE__{list: Enum.reverse(list)}
  end

  @doc """
  Check if the stack is empty.
  """
  @spec empty?(t) :: boolean
  def empty?(%__MODULE__{list: []}) do
    true
  end

  def empty?(%__MODULE__{}) do
    false
  end

  def clear(_) do
    %__MODULE__{list: []}
  end

  @doc """
  Check if the value is present in the stack.
  """
  @spec member?(t, v) :: boolean
  def member?(%__MODULE__{list: []}, _) do
    false
  end

  def member?(%__MODULE__{list: list}, value) do
    Enum.member?(list, value)
  end

  @doc """
  Get the size of the stack.
  """
  @spec size(t) :: non_neg_integer
  def size(%__MODULE__{list: list}) do
    length(list)
  end

  @doc """
  Fold the stack from the left.
  """
  @spec foldl(t, any, ((v, any) -> any)) :: any
  def foldl(%__MODULE__{list: list}, acc, fun) do
    List.foldl(list, acc, fun)
  end

  @doc """
  Fold the stack from the right.
  """
  @spec foldr(t, any, ((v, any) -> any)) :: any
  def foldr(%__MODULE__{list: list}, acc, fun) do
    List.foldr(list, acc, fun)
  end

  @doc """
  Convert the stack to a list.
  """
  @spec to_list(t) :: [v]
  def to_list(%__MODULE__{list: list}) do
    list
  end
end

defimpl Data.Stack, for: Data.Stack.Simple do
  defdelegate push(self, value), to: Data.Stack.Simple
  defdelegate pop(self), to: Data.Stack.Simple
  defdelegate pop(self, default), to: Data.Stack.Simple
  defdelegate pop!(self), to: Data.Stack.Simple
end

defimpl Data.Peekable, for: Data.Stack.Simple do
  defdelegate peek(self), to: Data.Stack.Simple
  defdelegate peek(self, default), to: Data.Stack.Simple
  defdelegate peek!(self), to: Data.Stack.Simple
end

defimpl Data.Reversible, for: Data.Stack.Simple do
  defdelegate reverse(self), to: Data.Stack.Simple
end

defimpl Data.Emptyable, for: Data.Stack.Simple do
  defdelegate empty?(self), to: Data.Stack.Simple
  defdelegate clear(self), to: Data.Stack.Simple
end

defimpl Data.Reducible, for: Data.Stack.Simple do
  defdelegate reduce(self, acc, fun), to: Data.Stack.Simple, as: :foldl
end

defimpl Data.Sequence, for: Data.Stack.Simple do
  def first(self) do
    Data.Stack.Simple.peek(self)
  end

  def next(self) do
    if Data.Stack.Simple.size(self) > 1 do
      { _, next } = Data.Stack.Simple.pop(self)

      next
    end
  end
end

defimpl Data.Listable, for: Data.Stack.Simple do
  defdelegate to_list(self), to: Data.Stack.Simple
end

defimpl Data.Contains, for: Data.Stack.Simple do
  defdelegate contains?(self, key), to: Data.Stack.Simple, as: :member?
end

defimpl Enumerable, for: Data.Stack.Simple do
  use Data.Enumerable
end

defimpl Inspect, for: Data.Stack.Simple do
  import Inspect.Algebra

  def inspect(stack, opts) do
    concat ["#Stack<", Kernel.inspect(Data.Stack.Simple.to_list(stack), opts), ">"]
  end
end

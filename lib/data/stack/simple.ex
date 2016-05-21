#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Stack.Simple do
  alias Data.Protocol, as: P
  alias __MODULE__, as: T

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
    %T{}
  end

  @doc """
  Creates a new stack from the given enumerable.

  ## Examples

      iex> T.new(1 .. 4)
      #Stack<[1,2,3,4]>

  """
  @spec new(Enum.t) :: t
  def new(enum) do
    %T{list: Data.to_list(enum)}
  end

  @doc """
  Push a value in the stack.

  ## Examples

      iex> T.new |> Stack.push(42) |> Stack.push(23) |> Stack.push(1337)
      #Stack<[1337,23,42]>

  """
  @spec push(t, v) :: t
  def push(%T{list: list}, value) do
    %T{list: [value | list]}
  end

  @doc """
  Pop a value from the stack.

  ## Examples

      iex> T.new |> Stack.push(42) |> Stack.push(23) |> Stack.pop
      {23,#Stack<[42]>}
      iex> T.new |> Stack.pop(:empty)
      {:empty,#Stack<[]>}

  """
  @spec pop(t) :: { v, t }
  def pop(%T{list: []}) do
    { :empty, %T{} }
  end

  def pop(%T{list: [head | rest]}) do
    { { :value, head }, %T{list: rest} }
  end

  @doc """
  Peek the element that would be popped.

  ## Examples

      iex> T.new |> Stack.push(42) |> Stack.peek
      42
      iex> T.new |> Stack.peek(:empty)
      :empty

  """
  @spec peek(t) :: v
  def peek(%T{list: []}) do
    :empty
  end

  def peek(%T{list: [head | _]}) do
    { :value, head }
  end

  @doc """
  Reverse the stack.

  ## Examples

      iex> T.new(1 .. 4) |> Stack.reverse
      #Stack<[4,3,2,1]>

  """
  @spec reverse(t) :: t
  def reverse(%T{list: list}) do
    %T{list: Enum.reverse(list)}
  end

  @doc """
  Check if the stack is empty.
  """
  @spec empty?(t) :: boolean
  def empty?(%T{list: []}) do
    true
  end

  def empty?(%T{}) do
    false
  end

  def clear(_) do
    %T{list: []}
  end

  @doc """
  Check if the value is present in the stack.
  """
  @spec member?(t, v) :: boolean
  def member?(%T{list: []}, _) do
    false
  end

  def member?(%T{list: list}, value) do
    Enum.member?(list, value)
  end

  @doc """
  Get the size of the stack.
  """
  @spec size(t) :: non_neg_integer
  def size(%T{list: list}) do
    length(list)
  end

  @doc """
  Fold the stack from the left.
  """
  @spec foldl(t, any, ((v, any) -> any)) :: any
  def foldl(%T{list: list}, acc, fun) do
    List.foldl(list, acc, fun)
  end

  @doc """
  Fold the stack from the right.
  """
  @spec foldr(t, any, ((v, any) -> any)) :: any
  def foldr(%T{list: list}, acc, fun) do
    List.foldr(list, acc, fun)
  end

  @doc """
  Convert the stack to a list.
  """
  @spec to_list(t) :: [v]
  def to_list(%T{list: list}) do
    list
  end

  defimpl P.Stack do
    defdelegate push(self, value), to: T
    defdelegate pop(self), to: T
  end

  defimpl P.Peek do
    defdelegate peek(self), to: T
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

  defimpl P.Sequence do
    def first(self) do
      Data.peek(self)
    end

    def next(self) do
      if T.size(self) > 1 do
        { _, next } = T.pop(self)

        next
      end
    end
  end

  defimpl P.ToList do
    defdelegate to_list(self), to: T
  end

  defimpl P.Contains do
    defdelegate contains?(self, key), to: T, as: :member?
  end

  defimpl P.Into do
    def into(self, value) do
      self |> T.push(value)
    end
  end

  defimpl Enumerable do
    use Data.Enumerable
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(stack, opts) do
      concat ["#Stack<", to_doc(T.to_list(stack), opts), ">"]
    end
  end
end

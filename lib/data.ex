#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data do
  defexception Empty, message: "the data is empty"

  @spec peek(Data.Peekable.t)      :: any
  @spec peek(Data.Peekable.t, any) :: any
  def peek(self, default // nil) do
    Data.Peekable.peek(self, default)
  end

  @spec peek!(Data.Peekable.t) :: any | no_return
  def peek!(self) do
    Data.Peekable.peek!(self)
  end

  @spec reduce(Data.Foldable.t, any, ((any, any) -> any)) :: any
  def reduce(self, acc, fun) do
    Data.Foldable.foldl(self, acc, fun)
  end

  @spec foldl(Data.Foldable.t, any, ((any, any) -> any)) :: any
  def foldl(self, acc, fun) do
    Data.Foldable.foldl(self, acc, fun)
  end

  @spec foldr(Data.Foldable.t, any, ((any, any) -> any)) :: any
  def foldr(self, acc, fun) do
    Data.Foldable.foldr(self, acc, fun)
  end

  @spec member?(Enumerable.t, any) :: Enumerable.t
  def member?(self, value) do
    Enum.member?(self, value)
  end

  @spec empty?(Data.Empytable.t) :: Data.Emptyable.t
  def empty?(self) do
    Data.Emptyable.empty?(self)
  end

  @spec clear(Data.Emptyable.t) :: Data.Emptyable.t
  def clear(self) do
    Data.Emptyable.clear(self)
  end

  @spec count(Data.Counted.t | Enumerable.t) :: Data.Counted.t | Enumerable.t
  def count(self) do
    if implements?(self, Data.Counted) do
      Data.Counted.count(self)
    else
      Enum.count(self)
    end
  end

  @spec reverse(Data.Reversible.t) :: Data.Reversible.t
  def reverse(self) do
    Data.Reversible.reverse(self)
  end

  @spec to_list(Data.Listable.t) :: list
  def to_list(self) do
    Data.Listable.to_list(self)
  end

  defp implements?(self, protocol) when is_record(self) do
    Code.ensure_loaded? Module.concat(protocol, elem(self, 0))
  end

  defp implements?(self, protocol) when is_list(self) do
    Code.ensure_loaded? Module.concat(protocol, List)
  end

  defp implements?(self, protocol, [{ name, arity }]) when is_record(self) do
    function_exported? Module.concat(protocol, elem(self, 0)), name, arity
  end

  defp implements?(self, protocol, [{ name, arity }]) when is_list(self) do
    function_exported? Module.concat(protocol, List), name, arity
  end
end

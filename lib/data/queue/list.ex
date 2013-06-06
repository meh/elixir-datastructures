#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defimpl Queue, for: List do
  def enq(list, value) do
    list ++ [value]
  end

  def deq(self, default // nil)

  def deq([], default) do
    { default, [] }
  end

  def deq([head | rest], _) do
    { head, rest }
  end

  def deq!([]) do
    raise Queue.Empty
  end

  def deq!(self) do
    deq(self)
  end

  def peek(self, default // nil)

  def peek([], default) do
    default
  end

  def peek([head | _], _) do
    head
  end

  def peek!([]) do
    raise Stack.Empty
  end

  def peek!(self) do
    peek(self)
  end

  def reverse(self) do
    Enum.reverse(self)
  end

  def empty?([]) do
    true
  end

  def empty?(_) do
    false
  end

  def member?(self, value) do
    Enum.member?(self, value)
  end

  def size(self) do
    length(self)
  end

  def foldl(self, acc, fun) do
    List.foldl(self, acc, fun)
  end

  def foldr(self, acc, fun) do
    List.foldr(self, acc, fun)
  end

  def to_list(self) do
    self
  end
end

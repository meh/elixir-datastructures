#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Queue do
  @type v :: any

  @spec enq(t, v) :: t
  def enq(self, value)

  @spec deq(t)    :: { v, t }
  @spec deq(t, v) :: { v, t }
  def deq(self, default // nil)

  @spec deq!(t) :: { v, t } | no_return
  def deq!(self)

  @spec peek(t)    :: v
  @spec peek(t, v) :: v
  def peek(self, default // nil)

  @spec peek!(t) :: v | no_return
  def peek!(self)

  @spec reverse(t) :: t
  def reverse(self)

  @spec empty?(t) :: boolean
  def empty?(self)

  @spec member?(t, v) :: boolean
  def member?(self, value)

  @spec size(t) :: non_neg_integer
  def size(self)

  @spec foldl(t, any, ((v, any) -> any)) :: any
  def foldl(self, acc, fun)

  @spec foldr(t, any, ((v, any) -> any)) :: any
  def foldr(self, acc, fun)

  @spec to_list(t) :: [v]
  def to_list(self)
end

defexception Queue.Empty, message: "the queue is empty"

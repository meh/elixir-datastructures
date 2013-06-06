#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Set do
  @type v :: any

  @spec member?(t, v) :: boolean
  def member?(self, value)

  @spec empty?(t) :: boolean
  def empty?(self)

  @spec add(t, v) :: t
  def add(self, value)

  @spec delete(t, v) :: t
  def delete(selv, value)

  @spec union(t, t) :: t
  def union(self, other)

  @spec intersection(t, t) :: t
  def intersection(self, other)

  @spec subset?(t, t) :: boolean
  def subset?(self, other)

  @spec disjoint?(t, t) :: boolean
  def disjoint?(self, other)

  @spec size(t) :: non_neg_integer
  def size(self)

  @spec reduce(t, any, ((v, any) -> any)) :: any
  def reduce(self, acc, fun)

  @spec to_list(t) :: [v]
  def to_list(self)
end

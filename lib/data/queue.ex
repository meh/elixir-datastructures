#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Queue do
  @type v :: any

  @spec enq(t, v) :: t
  def enq(self, value)

  @spec deq(t)    :: { v, t }
  @spec deq(t, v) :: { v, t }
  def deq(self, default \\ nil)

  @spec deq!(t) :: { v, t } | no_return
  def deq!(self)
end

defimpl Data.Queue, for: List do
  def new do
    []
  end

  def new(enum) do
    Data.to_list(enum)
  end

  def enq(list, value) do
    list ++ [value]
  end

  def deq(self, default \\ nil)

  def deq([], default) do
    { default, [] }
  end

  def deq([head | rest], _) do
    { head, rest }
  end

  def deq!([]) do
    raise Data.Empty
  end

  def deq!(self) do
    deq(self)
  end
end

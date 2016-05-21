#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Protocol.Queue do
  @type v :: any

  @spec enq(t, v) :: t
  def enq(self, value)

  @spec deq(t) :: { :empty, t } | { { :value, v }, t }
  def deq(self)
end

defimpl Data.Protocol.Queue, for: List do
  def new do
    []
  end

  def new(enum) do
    Data.to_list(enum)
  end

  def enq(list, value) do
    list ++ [value]
  end

  def deq([]) do
    :error
  end

  def deq([head | rest]) do
    { head, rest }
  end
end

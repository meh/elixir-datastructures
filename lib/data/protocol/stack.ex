#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Protocol.Stack do
  @type v :: any

  @spec push(t, v) :: t
  def push(self, value)

  @spec pop(t) :: { :empty, t } | { { :value, v }, t }
  def pop(self)
end

defimpl Data.Protocol.Stack, for: List do
  def new do
    []
  end

  def new(enum) do
    Data.to_list(enum)
  end

  def push(list, value) do
    [value | list]
  end

  def pop([]) do
    { :empty, [] }
  end

  def pop([head | rest]) do
    { { :value, head }, rest }
  end
end

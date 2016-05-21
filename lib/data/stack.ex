#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Stack do
  @type v :: any

  @spec push(t, v) :: t
  def push(self, value)

  @spec pop(t)    :: { v, t }
  @spec pop(t, v) :: { v, t }
  def pop(self, default \\ nil)

  @spec pop!(t) :: { v, t } | no_return
  def pop!(self)
end

defimpl Data.Stack, for: List do
  def new do
    []
  end

  def new(enum) do
    Data.to_list(enum)
  end

  def push(list, value) do
    [value | list]
  end

  def pop(self, default \\ nil)

  def pop([], default) do
    { default, [] }
  end

  def pop([head | rest], _) do
    { head, rest }
  end

  def pop!([]) do
    raise Data.Error.Empty
  end

  def pop!(self) do
    pop(self)
  end
end

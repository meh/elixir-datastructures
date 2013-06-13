#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Sequence do
  @type v :: any

  @spec first(t) :: v
  def first(self)

  @spec next(t) :: t | nil
  def next(self)
end

defimpl Data.Sequence, for: Atom do
  def first(nil) do
    nil
  end

  def next(nil) do
    nil
  end
end

defimpl Data.Sequence, for: List do
  def first([]) do
    nil
  end

  def first([head | _]) do
    head
  end

  def next([]) do
    nil
  end

  def next([_]) do
    nil
  end

  def next([_ | rest]) do
    rest
  end
end

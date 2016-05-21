#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

alias Data.Protocol.Sequence, as: Protocol

defprotocol Protocol do
  @type v :: any

  @spec first(t) :: v
  def first(self)

  @spec next(t) :: t | nil
  def next(self)
end

defimpl Protocol, for: Atom do
  def first(nil) do
    nil
  end

  def next(nil) do
    nil
  end
end

defimpl Protocol, for: List do
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

defimpl Protocol, for: Range do
  def first(first .. last) when first <= last or first > last do
    first
  end

  def first(_ .. _) do
    nil
  end

  def next(first .. last) when first == last do
    nil
  end

  def next(first .. last) when first <= last do
    first + 1 .. last
  end

  def next(first .. last) when first > last do
    first - 1 .. last
  end
end

defimpl Protocol, for: BitString do
  def first(string) do
    case String.next_grapheme(string) do
      :no_grapheme ->
        nil

      { first, _ } ->
        first
    end
  end

  def next(string) do
    case String.next_grapheme(string) do
      :no_grapheme ->
        nil

      { _, "" } ->
        nil

      { _, next } ->
        next
    end
  end
end

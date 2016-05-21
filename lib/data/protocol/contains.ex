#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Protocol.Contains do
  def contains?(self, what)
end

defimpl Data.Protocol.Contains, for: List do
  def contains?([], _) do
    false
  end

  def contains?([{ _, _ } | _] = self, { _, _ } = what) do
    :lists.member(what, self)
  end

  def contains?([{ _, _ } | _] = self, key) do
    :lists.keymember(key, 1, self)
  end

  def contains?(self, what) do
    :lists.member(what, self)
  end
end

defimpl Data.Protocol.Contains, for: Map do
  defdelegate contains?(self, key), to: Map, as: :has_key?
end

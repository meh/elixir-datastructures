#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

alias Data.Protocol.Dictionary, as: Protocol

defprotocol Protocol do
  @type k :: any
  @type v :: any

  @spec fetch(t, k) :: { :ok, v } | :error
  def fetch(self, key)

  @spec put(t, k, v) :: t
  def put(self, key, value)

  @spec delete(t, k) :: t
  def delete(self, key)

  @spec keys(t) :: [k]
  def keys(self)

  @spec values(t) :: [v]
  def values(self)
end

defimpl Protocol, for: List do
  def fetch(self, key) do
    case :lists.keyfind(key, 1, self) do
      { ^key, value } ->
        { :ok, value }

      false ->
        :error
    end
  end

  def put(self, key, value) do
    [{ key, value } | :lists.keydelete(key, 1, self)]
  end

  def delete(self, key) do
    :lists.keydelete(key, 1, self)
  end

  def keys(self) do
    for { key, _ } <- self, do: key
  end

  def values(self) do
    for { _, value } <- self, do: value
  end
end

defimpl Protocol, for: Map do
  defdelegate fetch(self, key), to: Map
  defdelegate put(self, key, value), to: Map
  defdelegate delete(self, key), to: Map
  defdelegate keys(self), to: Map
  defdelegate values(self), to: Map
end

defimpl Protocol, for: HashDict do
  defdelegate fetch(self, key), to: HashDict
  defdelegate put(self, key, value), to: HashDict
  defdelegate delete(self, key), to: HashDict
  defdelegate keys(self), to: HashDict
  defdelegate values(self), to: HashDict
end

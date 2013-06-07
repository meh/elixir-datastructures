#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defprotocol Data.Dictionary do
  @type k :: any
  @type v :: any

  @spec contains?(t, k) :: boolean
  def contains?(self, key)

  @spec get(t, k)    :: v
  @spec get(t, k, v) :: v
  def get(self, key, default // nil)

  @spec get!(t, k) :: v | no_return
  def get!(self, key)

  @spec put(t, k, v) :: t
  def put(self, key, value)

  @spec put_new(t, k, v) :: t
  def put_new(self, key, value)

  @spec update(t, k, (v -> v)) :: t | no_return
  def update(self, key, updater)

  @spec update(t, k, v, (v -> v)) :: t
  def update(self, key, value, updater)

  @spec delete(t, k) :: t
  def delete(self, key)

  @spec keys(t) :: [k]
  def keys(self)

  @spec values(t) :: [v]
  def values(self)
end

defimpl Data.Dictionary, for: List do
  def contains?(self, key) do
    :lists.keymember(key, 1, self)
  end

  def get(self, key, default // nil) do
    case :lists.keyfind(key, 1, self) do
      { ^key, value } ->
        value

      false ->
        default
    end
  end

  def get!(self, key) do
    case :lists.keyfind(key, 1, self) do
      { ^key, value } ->
        value

      false ->
        raise KeyError, key: key
    end
  end

  def put(self, key, value) do
    [{ key, value } | :lists.keydelete(key, 1, self)]
  end

  def put_new(self, key, value) do
    if contains?(self, key) do
      self
    else
      [{ key, value } | self]
    end
  end

  def update(self, key, updater) do
    case :lists.keyfind(key, 1, self) do
      { ^key, value } ->
        :lists.keyreplace(key, 1, self, { key, updater.(value) })

      false ->
        raise KeyError, key: key
    end
  end

  def update(self, key, initial, updater) do
    case :lists.keyfind(key, 1, self) do
      { ^key, value } ->
        :lists.keyreplace(key, 1, self, { key, updater.(value) })

      false ->
        [{ key, updater.(initial) } | self]
    end
  end

  def delete(self, key) do
    :lists.keydelete(key, 1, self)
  end

  def keys(self) do
    lc { key, _ } inlist self, do: key
  end

  def values(self) do
    lc { _, value } inlist self, do: value
  end
end

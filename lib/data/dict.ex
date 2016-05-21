#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Dict do
  alias Data.Protocol.Dictionary, as: D
  alias Data.Protocol.Contains, as: C
  alias Data.Seq, as: S

  defdelegate fetch(self, key), to: D
  defdelegate put(self, key, value), to: D
  defdelegate delete(self, key), to: D
  defdelegate keys(self), to: D
  defdelegate values(self), to: D

  def get(self, key, default \\ nil) do
    case D.fetch(self, key) do
      { :ok, value } ->
        value

      :error ->
        default
    end
  end

  def get!(self, key) do
    case D.fetch(self, key) do
      { :ok, value } ->
        value

      :error ->
        raise Data.Error.Missing, key: key
    end
  end

  def has_key?(self, key) do
    C.contains?(self, key)
  end

  def put_new(self, key, value) do
    if C.contains?(self, key) do
      self
    else
      D.put(self, key, value)
    end
  end

  def update(self, key, updater) do
    D.put(self, key, updater.(D.get!(self, key)))
  end

  def update(self, key, initial, updater) do
    D.put(self, key, updater.(D.get(self, key, initial)))
  end

  def merge(self, other) do
    S.reduce other, self, fn { name, value }, acc ->
      put acc, name, value
    end
  end

  def merge(self, other, merger) do
    S.reduce other, self, fn { name, value }, acc ->
      if C.contains?(self, name) do
        put acc, name, merger.(name, get(self, name), value)
      else
        put acc, name, value
      end
    end
  end
end

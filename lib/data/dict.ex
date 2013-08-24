#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Dict do
  alias Data.Dictionary, as: D
  alias Data.Contains, as: C
  alias Data.Sequence, as: S

  defdelegate get(self, key), to: D
  defdelegate get(self, key, default), to: D
  defdelegate get!(self, key), to: D
  defdelegate put(self, key, value), to: D
  defdelegate delete(self, key), to: D
  defdelegate keys(self), to: D
  defdelegate values(self), to: D

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
      put self, name, value
    end
  end
end

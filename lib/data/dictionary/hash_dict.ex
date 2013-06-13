#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defimpl Data.Dictionary, for: HashDict do
  defdelegate contains?(self, key), to: HashDict, as: :has_key?
  defdelegate get(self, key), to: HashDict
  defdelegate get(self, key, default), to: HashDict
  defdelegate get!(self, key), to: HashDict
  defdelegate put(self, key, value), to: HashDict
  defdelegate put_new(self, key, value), to: HashDict
  defdelegate update(self, key, updater), to: HashDict
  defdelegate update(self, key, value, updater), to: HashDict
  defdelegate delete(self, key), to: HashDict
  defdelegate keys(self), to: HashDict
  defdelegate values(self), to: HashDict
end

defimpl Data.Emptyable, for: HashDict do
  def empty?(self) do
    HashDict.size(self) == 0
  end

  def clear(self) do
    HashDict.empty(self)
  end
end

defimpl Data.Counted, for: HashDict do
  def count(self) do
    HashDict.size(self)
  end
end

defimpl Data.Foldable, for: HashDict do
  def foldl(self, acc, fun) do
    HashDict.reduce(self, acc, fun)
  end

  def foldr(self, acc, fun) do
    HashDict.reduce(self, acc, fun)
  end
end

defimpl Data.Listable, for: HashDict do
  def to_list(self) do
    HashDict.to_list(self)
  end
end

defimpl Data.Contains, for: HashDict do
  defdelegate contains?(self, key), to: HashDict, as: :has_key?
end

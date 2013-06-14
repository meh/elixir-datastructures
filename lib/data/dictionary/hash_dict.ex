#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defimpl Data.Dictionary, for: HashDict do
  defdelegate get(self, key), to: HashDict
  defdelegate get(self, key, default), to: HashDict
  defdelegate put(self, key, value), to: HashDict
  defdelegate delete(self, key), to: HashDict
  defdelegate keys(self), to: HashDict
  defdelegate values(self), to: HashDict

  def get!(self, key) do
    if HashDict.has_key?(self, key) do
      HashDict.get(self, key)
    else
      raise Data.Missing, key: key
    end
  end
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

defimpl Data.Reducible, for: HashDict do
  def reduce(self, acc, fun) do
    HashDict.reduce(self, acc, fun)
  end
end

defimpl Data.Listable, for: HashDict do
  def to_list(self) do
    HashDict.to_list(self)
  end
end

defimpl Data.Sequence, for: HashDict do
  def first(self) do
    HashDict.reduce(self, nil, fn(x, _) -> throw { :first, x } end)

    nil
  catch
    { :first, x } ->
      x
  end

  def next(self) do
    case HashDict.to_list(self) do
      [] ->
        nil

      [_] ->
        nil

      [_ | tail] ->
        tail
    end
  end
end

defimpl Data.Contains, for: HashDict do
  defdelegate contains?(self, key), to: HashDict, as: :has_key?
end

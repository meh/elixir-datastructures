#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

alias Data.Protocol, as: P

defimpl P.Dictionary, for: HashDict do
  defdelegate fetch(self, key), to: HashDict
  defdelegate put(self, key, value), to: HashDict
  defdelegate delete(self, key), to: HashDict
  defdelegate keys(self), to: HashDict
  defdelegate values(self), to: HashDict
end

defimpl P.Empty, for: HashDict do
  def empty?(self) do
    HashDict.size(self) == 0
  end

  defdelegate clear(self), to: HashDict, as: :empty
end

defimpl P.Count, for: HashDict do
  defdelegate count(self), to: HashDict, as: :size
end

defimpl P.Reduce, for: HashDict do
  defdelegate reduce(self, acc, fun), to: HashDict
end

defimpl P.ToList, for: HashDict do
  defdelegate to_list(self), to: HashDict
end

defimpl P.Contains, for: HashDict do
  defdelegate contains?(self, key), to: HashDict, as: :has_key?
end

#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Dictionary.Standard do
  @behaviour Dict

  defrecordp :wrap, dict: nil

  def new do
    wrap(dict: :dict.new)
  end

  def new(enum_or_dict) do
    wrap(dict: Data.to_list(enum_or_dict) |> :dict.from_list)
  end

  def has_key?(wrap(dict: self), key) do
    :dict.is_key(key, self)
  end

  def get(wrap(dict: self), key, default // nil) do
    case :dict.find(key, self) do
      { :ok, value } ->
        value

      :error ->
        default
    end
  end

  def get!(wrap(dict: self), key) do
    case :dict.find(key, self) do
      { :ok, value } ->
        value

      :error ->
        raise Data.Missing, key: key
    end
  end

  def put(wrap(dict: self), key, value) do
    wrap(dict: :dict.store(key, value, self))
  end

  def put_new(wrap(dict: self), key, value) do
    if :dict.is_key(key, self) do
      wrap(dict: self)
    else
      wrap(dict: :dict.store(key, value, self))
    end
  end

  def update(wrap(dict: self), key, updater) do
    if :dict.is_key(key, self) do
      wrap(dict: :dict.update(key, updater, self))
    else
      raise Data.Missing, key: key
    end
  end

  def update(wrap(dict: self), key, initial, updater) do
    wrap(dict: :dict.update(key, updater, initial, self))
  end

  def delete(wrap(dict: self), key) do
    wrap(dict: :dict.erase(key, self))
  end

  def keys(wrap(dict: self)) do
    :dict.fetch_keys(self)
  end

  def values(wrap(dict: self)) do
    :dict.fold(fn { _, value }, acc -> [value | acc] end, [], self)
  end

  def reduce(wrap(dict: self), acc, fun) do
    :dict.fold(fun, acc, self)
  end

  def size(wrap(dict: self)) do
    :dict.size(self)
  end

  def empty(_) do
    new
  end

  def to_list(wrap(dict: self)) do
    :dict.to_list(self)
  end

  def member?(wrap(dict: self), { key, value }) do
    case :dict.find(key, self) do
      { :ok, ^value } ->
        true

      _ ->
        false
    end
  end

  def member?(wrap(dict: self), key) do
    :dict.is_key(key, self)
  end
end

defimpl Data.Dictionary, for: Data.Dictionary.Standard do
  defdelegate get(self, key), to: Data.Dictionary.Standard
  defdelegate get(self, key, default), to: Data.Dictionary.Standard
  defdelegate get!(self, key), to: Data.Dictionary.Standard
  defdelegate put(self, key, value), to: Data.Dictionary.Standard
  defdelegate delete(self, key), to: Data.Dictionary.Standard
  defdelegate keys(self), to: Data.Dictionary.Standard
  defdelegate values(self), to: Data.Dictionary.Standard
end

defimpl Data.Counted, for: Data.Dictionary.Standard do
  defdelegate count(self), to: Data.Dictionary.Standard, as: :size
end

defimpl Data.Emptyable, for: Data.Dictionary.Standard do
  def empty?(self) do
    Data.Dictionary.Standard.size(self) == 0
  end

  defdelegate clear(self), to: Data.Dictionary.Standard, as: :empty
end

defimpl Data.Foldable, for: Data.Dictionary.Standard do
  defdelegate foldl(self, acc, fun), to: Data.Dictionary.Standard, as: :reduce
  defdelegate foldr(self, acc, fun), to: Data.Dictionary.Standard, as: :reduce
end

defimpl Data.Listable, for: Data.Dictionary.Standard do
  defdelegate to_list(self), to: Data.Dictionary.Standard
end

defimpl Data.Contains, for: Data.Dictionary.Standard do
  defdelegate contains?(self, key), to: Data.Dictionary.Standard, as: :member?
end

defimpl Enumerable, for: Data.Dictionary.Standard do
  defdelegate reduce(self, acc, fun), to: Data.Dictionary.Standard
  defdelegate count(self), to: Data.Dictionary.Standard, as: :size
  defdelegate member?(self, key), to: Data.Dictionary.Standard
end

defimpl Binary.Inspect, for: Data.Dictionary.Standard do
  def inspect(self, opts) do
    "#Dictionary<" <> Kernel.inspect(Data.Dictionary.Standard.to_list(self), opts) <> ">"
  end
end

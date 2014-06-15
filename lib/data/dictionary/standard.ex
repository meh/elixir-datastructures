#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Dictionary.Standard do
  require Record

  Record.defrecordp :wrap, __MODULE__, dict: nil

  def new do
    wrap(dict: :dict.new)
  end

  def new(enum_or_dict) do
    wrap(dict: Data.to_list(enum_or_dict) |> :dict.from_list)
  end

  def has_key?(wrap(dict: self), key) do
    :dict.is_key(key, self)
  end

  def get(wrap(dict: self), key, default \\ nil) do
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

  def delete(wrap(dict: self), key) do
    wrap(dict: :dict.erase(key, self))
  end

  def keys(wrap(dict: self)) do
    :dict.fetch_keys(self)
  end

  def values(wrap(dict: self)) do
    :dict.fold(fn(_, value, acc) -> [value | acc] end, [], self)
  end

  def reduce(wrap(dict: self), acc, fun) do
    :dict.fold(fn(key, value, acc) -> fun.({ key, value }, acc) end, acc, self)
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

defimpl Data.Reducible, for: Data.Dictionary.Standard do
  defdelegate reduce(self, acc, fun), to: Data.Dictionary.Standard
end

defimpl Data.Listable, for: Data.Dictionary.Standard do
  defdelegate to_list(self), to: Data.Dictionary.Standard
end

defimpl Data.Contains, for: Data.Dictionary.Standard do
  defdelegate contains?(self, key), to: Data.Dictionary.Standard, as: :member?
end

defimpl Data.Sequence, for: Data.Dictionary.Standard do
  def first(self) do
    Data.Dictionary.Standard.reduce(self, nil, fn(x, _) -> throw { :first, x } end)

    nil
  catch
    { :first, x } ->
      x
  end

  def next(self) do
    case Data.Dictionary.Standard.to_list(self) do
      [] ->
        nil

      [_] ->
        nil

      [_ | tail] ->
        tail
    end
  end
end

defimpl Enumerable, for: Data.Dictionary.Standard do
  use Data.Enumerable
end

defimpl Access, for: Data.Dictionary.Standard do
  defdelegate access(self, key), to: Data.Dictionary.Standard, as: :get
end

defimpl Inspect, for: Data.Dictionary.Standard do
  import Inspect.Algebra

  def inspect(self, opts) do
    concat ["#Dictionary<", Kernel.inspect(Data.Dictionary.Standard.to_list(self), opts), ">"]
  end
end

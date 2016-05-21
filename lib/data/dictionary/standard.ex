#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Dictionary.Standard do
  alias Data.Protocol, as: P
  alias __MODULE__, as: T

  defstruct [:dict]

  def new do
    %T{dict: :dict.new}
  end

  def new(enum_or_dict) do
    %T{dict: Data.to_list(enum_or_dict) |> :dict.from_list}
  end

  def has_key?(%T{dict: self}, key) do
    :dict.is_key(key, self)
  end

  def fetch(%T{dict: self}, key) do
    :dict.find(key, self)
  end

  def put(%T{dict: self}, key, value) do
    %T{dict: :dict.store(key, value, self)}
  end

  def put_new(%T{dict: self}, key, value) do
    if :dict.is_key(key, self) do
      %T{dict: self}
    else
      %T{dict: :dict.store(key, value, self)}
    end
  end

  def delete(%T{dict: self}, key) do
    %T{dict: :dict.erase(key, self)}
  end

  def keys(%T{dict: self}) do
    :dict.fetch_keys(self)
  end

  def values(%T{dict: self}) do
    :dict.fold(fn(_, value, acc) -> [value | acc] end, [], self)
  end

  def reduce(%T{dict: self}, acc, fun) do
    :dict.fold(fn(key, value, acc) -> fun.({ key, value }, acc) end, acc, self)
  end

  def size(%T{dict: self}) do
    :dict.size(self)
  end

  def empty(_) do
    new
  end

  def to_list(%T{dict: self}) do
    :dict.to_list(self)
  end

  def member?(%T{dict: self}, { key, value }) do
    case :dict.find(key, self) do
      { :ok, ^value } ->
        true

      _ ->
        false
    end
  end

  def member?(%T{dict: self}, key) do
    :dict.is_key(key, self)
  end

  defimpl P.Dictionary do
    defdelegate fetch(self, key), to: T
    defdelegate put(self, key, value), to: T
    defdelegate delete(self, key), to: T
    defdelegate keys(self), to: T
    defdelegate values(self), to: T
  end

  defimpl P.Count do
    defdelegate count(self), to: T, as: :size
  end

  defimpl P.Empty do
    def empty?(self) do
      T.size(self) == 0
    end

    defdelegate clear(self), to: T, as: :empty
  end

  defimpl P.Reduce do
    defdelegate reduce(self, acc, fun), to: T
  end

  defimpl P.ToList do
    defdelegate to_list(self), to: T
  end

  defimpl P.Contains do
    defdelegate contains?(self, key), to: T, as: :member?
  end

  # FIXME: this is crap
  defimpl P.Sequence do
    def first(self) do
      T.reduce(self, nil, fn(x, _) -> throw { :first, x } end)

      nil
    catch
      { :first, x } ->
        x
    end

    def next(self) do
      case T.to_list(self) do
        [] ->
          nil

        [_] ->
          nil

        [_ | tail] ->
          tail
      end
    end
  end

  defimpl P.Into do
    def into(self, { key, value }) do
      self |> T.put(key, value)
    end
  end

  defimpl Enumerable do
    use Data.Enumerable
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(self, opts) do
      concat ["#Dictionary<", to_doc(T.to_list(self), opts), ">"]
    end
  end
end

#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Dictionary.Standard do
  alias Data.Protocol, as: P

  defstruct [:dict]

  def new do
    %__MODULE__{dict: :dict.new}
  end

  def new(enum_or_dict) do
    %__MODULE__{dict: Data.to_list(enum_or_dict) |> :dict.from_list}
  end

  def has_key?(%__MODULE__{dict: self}, key) do
    :dict.is_key(key, self)
  end

  def fetch(%__MODULE__{dict: self}, key) do
    :dict.find(key, self)
  end

  def put(%__MODULE__{dict: self}, key, value) do
    %__MODULE__{dict: :dict.store(key, value, self)}
  end

  def put_new(%__MODULE__{dict: self}, key, value) do
    if :dict.is_key(key, self) do
      %__MODULE__{dict: self}
    else
      %__MODULE__{dict: :dict.store(key, value, self)}
    end
  end

  def delete(%__MODULE__{dict: self}, key) do
    %__MODULE__{dict: :dict.erase(key, self)}
  end

  def keys(%__MODULE__{dict: self}) do
    :dict.fetch_keys(self)
  end

  def values(%__MODULE__{dict: self}) do
    :dict.fold(fn(_, value, acc) -> [value | acc] end, [], self)
  end

  def reduce(%__MODULE__{dict: self}, acc, fun) do
    :dict.fold(fn(key, value, acc) -> fun.({ key, value }, acc) end, acc, self)
  end

  def size(%__MODULE__{dict: self}) do
    :dict.size(self)
  end

  def empty(_) do
    new
  end

  def to_list(%__MODULE__{dict: self}) do
    :dict.to_list(self)
  end

  def member?(%__MODULE__{dict: self}, { key, value }) do
    case :dict.find(key, self) do
      { :ok, ^value } ->
        true

      _ ->
        false
    end
  end

  def member?(%__MODULE__{dict: self}, key) do
    :dict.is_key(key, self)
  end

  defimpl P.Dictionary do
    defdelegate fetch(self, key), to: Data.Dictionary.Standard
    defdelegate put(self, key, value), to: Data.Dictionary.Standard
    defdelegate delete(self, key), to: Data.Dictionary.Standard
    defdelegate keys(self), to: Data.Dictionary.Standard
    defdelegate values(self), to: Data.Dictionary.Standard
  end

  defimpl P.Count do
    defdelegate count(self), to: Data.Dictionary.Standard, as: :size
  end

  defimpl P.Empty do
    def empty?(self) do
      Data.Dictionary.Standard.size(self) == 0
    end

    defdelegate clear(self), to: Data.Dictionary.Standard, as: :empty
  end

  defimpl P.Reduce do
    defdelegate reduce(self, acc, fun), to: Data.Dictionary.Standard
  end

  defimpl P.ToList do
    defdelegate to_list(self), to: Data.Dictionary.Standard
  end

  defimpl P.Contains do
    defdelegate contains?(self, key), to: Data.Dictionary.Standard, as: :member?
  end

  defimpl P.Sequence do
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

  defimpl Enumerable do
    use Data.Enumerable
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(self, opts) do
      concat ["#Dictionary<", Kernel.inspect(Data.Dictionary.Standard.to_list(self), opts), ">"]
    end
  end
end

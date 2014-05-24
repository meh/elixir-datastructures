#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Empty do
  defexception [:message]
  def exception(_) do
    %Data.Empty{message: "the data is empty"}
  end
end

defexception Data.OutOfBounds, message: "out of bounds"

defmodule Data.Missing do
  defexception [:message, :key, :what]
  
  def exception(opts) do
    cond do
      key = opts[:key] != nil ->
        %Data.Missing{message: "key missing: #{inspect key}", key: key}
      what = opts[:what] != nil ->
        %Data.Missing{message: "#{inspect what} is missing", what: what}
    end
  end
end

#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defexception Data.Empty, message: "the data is empty"
defexception Data.OutOfBounds, message: "out of bounds"

defexception Data.Missing, key: nil, what: nil do
  def message( key ) when key != nil do
    "key missing: #{inspect key}"
  end

  def message( what ) when what != nil do
    "#{inspect what} is missing"
  end
end

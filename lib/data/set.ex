#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Set do
  alias Data.Protocol.Set, as: S

  defdelegate add(self, value), to: S
  defdelegate delete(self, value), to: S
  defdelegate union(self, other), to: S
  defdelegate intersection(self, other), to: S
  defdelegate difference(self, other), to: S
  defdelegate subset?(self, other), to: S
  defdelegate disjoint?(self, other), to: S
end

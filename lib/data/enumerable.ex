#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Data.Enumerable do
  defmacro __using__(_opts) do
    quote do
      defdelegate member?(self, value), to: Data, as: :contains?
      defdelegate count(self), to: Data, as: :count

      def reduce(_, { :halt, acc }, _fun) do
        { :halted, acc }
      end

      def reduce(seq, { :suspend, acc }, fun) do
        { :suspended, acc, &reduce(seq, &1, fun) }
      end

      def reduce(nil, { :cont, acc }, _fun) do
        { :done, acc }
      end

      def reduce(seq, { :cont, acc }, fun) do
        reduce(Data.Seq.next(seq), fun.(Data.Seq.first(seq), acc), fun)
      end
    end
  end
end

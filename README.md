Datastructures for Elixir
=========================
This is a collection of protocols, implementations and wrappers to work with
datastructures.

The stdlib of Elixir right now is very poor and every now and then you have to
end up using the Erlang libraries, which have different APIs from the rest of
idiomatic Elixir and on top of that they lose all the protocol goodies.

Protocols and their implementations
-----------------------------------

### Set

  * Data.Set.List *(ordsets)*
  * Data.Set.BalancedTree *(gb_sets)*
  * Data.Set.Standard *(sets)*

### Queue

  * Data.Queue.List
  * Data.Queue.Standard *(queue)*
  * Data.Queue.Simple

### Stack

  * Data.Stack.List
  * Data.Stack.Simple
  * Data.Queue.Standard *(queue)*

### Dictionary

You're awful, those names are long
----------------------------------
I know right? Just use `alias`.

```elixir
alias Data.Set.BalancedTree, as: SBT

SBT.new |> Set.add(23) |> Set.add(42) # => #Set<[23,42]>
```

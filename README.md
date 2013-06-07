Datastructures for Elixir
=========================
This is a collection of protocols, implementations and wrappers to work with
datastructures.

The stdlib of Elixir right now is very poor and every now so you end up using
the Erlang libraries, which have different APIs from the rest of idiomatic
Elixir, and on top of that they lose all the protocol goodies.

Protocols
---------

### Counted
  * `count` - returns the length of the structure

### Emptyable
  * `empty?/1` - checks if the structure is empty
  * `clear/1` - returns an empty structure

### Foldable
  * `foldl/3` - folds the structure from the left
  * `foldr/3` - folds the structure from the right

### Listable
  * `to_list/1` - converts the structure to a list

### Peekable
  * `peek/1` - peeks and returns nil if the structure empty
  * `peek/2` - peeks and returns the default value if the structure empty
  * `peek!/1` - peeks and raises if the structure is empty

### Reversible
  * `reverse/1` - reverses the structure

### Queue
  * `enq/2` - enqueues a value in the structure
  * `deq/1` - dequeues a value from the structure, returning nil if it's empty
  * `deq/2` - dequeues a value from the structure, returning the default if it's empty
  * `deq!/1` - dequeues a value from the structure, raising if it's empty

### Stack
  * `push/2` - pushes a value in the structure
  * `pop/1` - pops a value from the structure, returning nil if it's empty
  * `pop/2` - pops a value from the structure, returning the default if it's empty
  * `pop!/1` - pops a value from the structure, raising if it's empty

### Set
  * `add/2` - adds a value to the structure
  * `delete/2` - deletes a value from the structure
  * `union/2` - returns the union of the two structures
  * `intersection/2` - returns the intersection of the two structures
  * `subset?/2` - checks if the two structures are subsets
  * `disjoint?/2` - checks if the two structures are disjoint

You're awful, those names are long
----------------------------------
I know right? Just use `alias`.

```elixir
alias Data.Set, as: S
alias Data.Set.BalancedTree, as: SBT

SBT.new |> S.add(23) |> S.add(42) # => #Set<[23,42]>
```

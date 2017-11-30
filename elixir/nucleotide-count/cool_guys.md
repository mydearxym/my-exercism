
[Enum count](http://exercism.io/submissions/ecd6b08496a743a78684542f574cfcca)

```elixir
@spec count([char], char) :: non_neg_integer
def count(strand, nucleotide) do
  Enum.count(strand, &(&1 == nucleotide))
end

@spec histogram([char]) :: map
def histogram(strand) do
  Map.new(@nucleotides, &({&1, count(strand, &1)}))
end

# or
def histogram(strand) do
  @nucleotides
    |> Map.new(&({&1, count(strand, &1)}))
end
```

[filter count](http://exercism.io/submissions/c9029b1d96f845fb8d9f6dce1f2ab549)

```elixir
@spec count([char], char) :: non_neg_integer
def count('', _) do
  0
end

def count(strand, nucleotide) do
  Enum.filter(strand, fn(x) -> x == nucleotide end)
  |> length
end

def histogram(strand) do
  for n <- @nucleotides, into: %{}, do: {n, count(strand, n)}
end
```

[reduce](http://exercism.io/submissions/61658cceb7c7497eb58e321254ca6610)

```elixir
@spec count([char], char) :: non_neg_integer
def count(strand, nucleotide) do
  Enum.reduce(strand, 0, fn(x, acc) ->
    if x == nucleotide, do: acc + 1, else: acc
  end)
end
```

[patten match](http://exercism.io/submissions/2eb2fc501ad64d02a5d722b9a81863ea)

NucleotideCount.count('AATAA', ?A) => 4
A | ATAA
A | TAA
T | AA
AA
A | A
count(A, A)

```elixir
@spec count([char], char) :: non_neg_integer
def count([], nucleotide) do
  0
end

def count([nucleotide | tail], nucleotide) do
    1 + count(tail, nucleotide)
end

def count([_strand | tail], nucleotide) do
  0 + count(tail, nucleotide)
end
```

[better patten match](http://exercism.io/submissions/40d827d454d1423c95b06c58285c49e3)

```elixir
@spec count([char], char) :: non_neg_integer
def count(strand, nucleotide) do
  count(strand, nucleotide, 0)
end

@spec count([char], char) :: non_neg_integer
def count([nucleotide|tail], nucleotide, total) do
  count(tail, nucleotide, total+1)
end

@spec count([char], char) :: non_neg_integer
def count([_|tail], nucleotide, total) do
  count(tail, nucleotide, total)
end

@spec count([char], char) :: non_neg_integer
def count([], _, total) do
  total
end
```


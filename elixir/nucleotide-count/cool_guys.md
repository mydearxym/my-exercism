
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





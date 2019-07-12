
[模式匹配](http://exercism.io/submissions/92ff550c025a4b4dae30cd403ffa571d)

```Elixir

Enum.any?(results, &error?/1) do
... 

defp error?({:error, _message}), do: true
defp error?({:ok, _result}), do: false

------------

Stream.take_while(&not_stop_protein?/1)

defp not_stop_protein?({:ok, "STOP"}) do: false 
defp not_stop_protein?(_) do: true
  
```

[cond usage](http://exercism.io/submissions/2c3dd3406bd14c71b25d21f553727fbd)

```Elixir
@spec of_codon(String.t()) :: { atom, String.t() }
def of_codon(codon) do
  try do
    {:ok, cond do
      codon in ["UGU", "UGC"] -> "Cysteine"
      codon in ["UUA", "UUG"] -> "Leucine"
      codon in ["AUG"] -> "Methionine"
      codon in ["UUC", "UUU"] -> "Phenylalanine"
      codon in ["UCU", "UCC", "UCA", "UCG"] -> "Serine"
      codon in ["UGG"] -> "Tryptophan"
      codon in ["UAU", "UAC"] -> "Tyrosine"
      codon in ["UAA", "UAG", "UGA"] -> "STOP"
    end}
  rescue
    CondClauseError -> {:error, "invalid codon"}
  end
end
```

[另一种 compose 思路](http://exercism.io/submissions/0b9ca6601b314b8a9c2ec3595fed9ae9)

```Elixir
def of_rna(rna) do
  rna 
    |> Stream.unfold(&String.split_at(&1, 3))
    |> Enum.take_while(&(&1 != ""))
    |> translate 
    |> check_if_stopped
    |> check_if_invalid
    |> convert_to_tuple
end
```

[工整派, 递归](http://exercism.io/submissions/ee5f9361a7ab4c6598407d7b6d16c610)
停止的思路很巧妙, 遇到 Stop 就返回，没遇到就继续递归
```Elixir
  defp of_codons([codon|tail], proteins) do
    case of_codon(codon) do
      {:error, _} -> {:error, "invalid RNA"}
      {:ok, "STOP"} -> {:ok, proteins}
      {:ok, protein} -> of_codons(tail, proteins ++ [protein])
    end
  end
```

常见这样的逻辑： 在返回时使用 case 做判断
[case 1](http://exercism.io/submissions/303beecd0cb34fb7a2e8d47666a28b5f)

```Elixir
def of_rna(rna) do
  rna =  List.flatten(Regex.scan(~r/.../, rna))
      |> Enum.map(&Map.get(@to_proteins,&1))
      |> Enum.take_while(&(&1 != "STOP"))
  
  case Enum.all?(rna) do 
      true  -> {:ok, rna}
      other -> {:error, "invalid RNA"}
  end
end
```



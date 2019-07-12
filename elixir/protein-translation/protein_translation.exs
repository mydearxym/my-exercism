defmodule ProteinTranslation do
  @proteins %{
    "UGU" => "Cysteine",
    "UGC" => "Cysteine",
    "UUA" => "Leucine",
    "UUG" => "Leucine",
    "AUG" => "Methionine",
    "UUU" => "Phenylalanine",
    "UUC" => "Phenylalanine",
    "UCU" => "Serine",
    "UCC" => "Serine",
    "UCA" => "Serine",
    "UCG" => "Serine",
    "UGG" => "Tryptophan",
    "UAU" => "Tyrosine",
    "UAC" => "Tyrosine",
    "UAA" => "STOP",
    "UAG" => "STOP",
    "UGA" => "STOP"
  }

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: { atom,  list(String.t()) }
  def of_rna(rna) do
    rna
    |> to_charlist
    |> Stream.chunk_every(3)
    |> Stream.map(&get_codon/1)
    |> Enum.take_while(R.not_equal("STOP"))
    # |> Enum.take_while(&(String.equivalent?(&1, "STOP") ))
    |> datapack
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: { atom, String.t() }
  def of_codon(codon) do
    # case Map.fetch(@proteins, codon) do
    # codon
    # |> R.get_codon(@proteins)
    # |> IO.inspect(label: "nihao")

    case get_codon(codon) do
      nil -> {:error, "invalid codon"}
      protein -> {:ok, protein}
    end
      # sentence when byte_size(sentence) > 3 -> { :ok, ~w(Methionine Phenylalanine Tryptophan) }
  end

  defp datapack(value) do
    cond do
      is_binary(value)  -> Tuple.append({:ok}, value)
      any_nil?(value)   -> {:error, "invalid RNA"}
      true              -> Tuple.append({:ok}, value)
    end
  end

  defp get_codon(codon) do
    @proteins
    |> Map.get(to_string(codon))
  end

  defp any_nil?(val) do
    val
    |> Enum.any?(R.is_nil)
  end
end


# http://blog.patrikstorm.com/function-currying-in-elixir
defmodule R do
  # @spec of_codon(String.t()) :: { atom, String.t() }

  @spec not_equal(String.t()) :: (String.t() -> any)
  def not_equal(target) do
    R.curry(
      fn source ->
        target != source
      end
    )
  end

  @spec not_equal(any) :: (any -> any)
  def is_nil() do
    R.curry(
      fn val ->
        is_nil(val)
      end
    )
  end

  @spec curry(function) :: (any -> any)
  def curry(fun) when is_function(fun) do
    {_, arity} = :erlang.fun_info(fun, :arity)
    curry(fun, arity, [])
  end

  @spec curry(function) :: (any -> any)
  def curry(fun, 0, arguments) when is_function(fun) do
    apply(fun, Enum.reverse arguments)
  end

  @spec curry(function) :: (any -> any)
  def curry(fun, arity, arguments) when is_function(fun) do
    fn arg -> curry(fun, arity - 1, [arg | arguments]) end
  end
end

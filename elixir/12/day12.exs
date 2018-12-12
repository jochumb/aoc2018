defmodule Day12 do

  def plants(pots, i \\ 0, acc \\ [])
  def plants([], _, acc), do: MapSet.new(acc)
  def plants(["."|t], i, acc), do: plants(t, i + 1, acc)
  def plants(["#"|t], i, acc), do: plants(t, i + 1, [i|acc])

  def translation([pattern, _, val|_]) do
    key = pattern 
      |> String.codepoints 
      |> Enum.map(&Day12.replace/1) 
      |> Enum.map(&Integer.to_string/1) 
      |> Enum.join 
      |> String.to_integer(2)
    {key, replace(val)}
  end

  def replace("."), do: 0
  def replace("#"), do: 1

  def next(plants, translations) do
    next = for pot <- Enum.to_list(Enum.min(plants)-2..Enum.max(plants)+2),
               do: fill(pot, plants, translations)
    next |> List.flatten |> MapSet.new
  end

  defp fill(pot, plants, translations) do
    key = create_key(pot, plants)
    case Map.get(translations, key, 0) do
      1 -> [pot]
      _ -> []
    end
  end

  defp create_key(pot, plants) do
    key = for p <- pot-2..pot+2, do: plant(p, plants)
    key |> Enum.join |> String.to_integer(2)
  end

  defp plant(pot, plants) do
    case MapSet.member?(plants, pot) do
      true -> "1"
      false -> "0"
    end
  end
end

input = File.stream!("input") |> Enum.map(&String.trim_trailing/1)

plants = input 
  |> hd 
  |> String.split 
  |> fn [_,_,pots|_] -> pots end.()
  |> String.codepoints
  |> Day12.plants

translations = input
  |> Enum.drop(2)
  |> Enum.map(&String.split/1)
  |> Enum.map(&Day12.translation/1)
  |> Map.new

1..20 
|> Enum.reduce(plants, fn _, acc -> Day12.next(acc, translations) end) 
|> Enum.sum 
|> IO.puts

res = 1..2_000 
|> Enum.reduce(plants, fn _, acc -> Day12.next(acc, translations) end) 
|> Enum.sum

magic_number = 73
res + magic_number*(50_000_000_000-2000) |> IO.puts
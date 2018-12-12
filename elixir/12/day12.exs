defmodule Day12 do
  def plants(pots, i \\ 0, acc \\ [])
  def plants([], _, acc), do: MapSet.new(acc)
  def plants(["."|t], i, acc), do: plants(t, i + 1, acc)
  def plants(["#"|t], i, acc), do: plants(t, i + 1, [i|acc])

  def translation([key, _, val|_]), do: {key, val}

  def next(plants, translations) do
    next = for pot <- Enum.min(plants)-2..Enum.max(plants)+2,
               do: fill(pot, plants, translations)
    next |> List.flatten |> MapSet.new
  end

  defp fill(pot, plants, translations) do
    key = create_key(pot, plants)
    case Map.get(translations, key, ".") do
      "#" -> [pot]
      _   -> []
    end
  end

  defp create_key(pot, plants) do
    (for p <- pot-2..pot+2, do: plant(p, plants)) |> Enum.join
  end

  defp plant(pot, plants) do
    case MapSet.member?(plants, pot) do
      true  -> "#"
      false -> "."
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

# Part 1
1..20 
|> Enum.reduce(plants, fn _, acc -> Day12.next(acc, translations) end) 
|> Enum.sum 
|> IO.puts

# Part 2
generations = 50_000_000_000

{sum, diff, generation} = 1..generations 
|> Enum.reduce_while({plants, 0, 0}, 
  fn g, {p, sum, diff} -> 
    np = Day12.next(p, translations)
    ns = Enum.sum(np)
    nd = ns - sum
    case diff == nd do
      true  -> {:halt, {ns, nd, g}}
      false -> {:cont, {np, ns, nd}}
    end
  end) 

IO.puts sum + (generations-generation) * diff

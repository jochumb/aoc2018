defmodule Day14 do
  def score_from(recipes) do
    iterate(%{0 => 3, 1 => 7}, {0,1}, String.to_integer(recipes))
  end

  def recipes_before(recipes) do
    iterate2(%{0 => 3, 1 => 7}, {0,1}, :binary.compile_pattern(recipes), String.length(recipes))
  end

  def iterate(map, pos, recipes) do
    case map_size(map) do
      size when size >= recipes + 10 -> scores(map, recipes) 
      size -> next(map, pos, size) |> fn {nm, np} -> iterate(nm, np, recipes) end.()
    end
  end

  def iterate2(map, pos, recipes, length) do
    size = map_size(map)
    case recipes_at_end(map, size, recipes, length) do
      {:ok, count} -> count
      :cont -> next(map, pos, size) |> fn {nm, np} -> iterate2(nm, np, recipes, length) end.()
    end
  end

  def scores(map, recipes) do 
    map 
    |> Map.to_list 
    |> Enum.sort
    |> Enum.map(fn {_,v} -> v end)
    |> Enum.drop(recipes) 
    |> Enum.take(10) 
    |> Enum.map(&Integer.to_string/1) 
    |> Enum.join
  end

  def next(map, {a,b}, size) do
    %{^a => a_val, ^b => b_val} = map
    {new_map, c} = case a_val + b_val do
      n when n > 9 -> {Map.put(map, size, 1) |> Map.put(size+1, n-10),2}
      n -> {Map.put(map, size, n),1}
    end
    new_pos = {rem(a + a_val + 1, size + c), rem(b + b_val + 1, size + c)}
    {new_map, new_pos}
  end

  def recipes_at_end(_, size, _, length) when size <= length, do: :cont
  def recipes_at_end(map, size, recipes, length) do
    split = size-(length+1)..size-1 
      |> Enum.map(fn n -> Map.get(map, n) end) 
      |> Enum.map(&Integer.to_string/1) 
      |> Enum.join
      |> String.split(recipes)
    case split do
      ["",_|[]] -> {:ok, size-length}
      [_,""|[]] -> {:ok, size-(length+1)}
      _         -> :cont
    end
  end
end

from = System.argv() |> fn 
    [] -> ["047801"]
    args -> args
  end.() |> hd

from |> Day14.score_from |> IO.puts
from |> Day14.recipes_before |> IO.puts


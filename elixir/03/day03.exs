defmodule Day03 do
  def pointmap([_, id, _, _, x, y, _, dx, dy|_]) do
    area({x,y,dx,dy}) |> Enum.map(&({&1, [id]})) |> Map.new
  end

  def idarea([_, id, _, _, x, y, _, dx, dy|_]), do: {id, area({x,y,dx,dy})}

  defp area({x, y, dx, dy}) do
    for px <- x+1..x+dx,
        py <- y+1..y+dy,
        into: MapSet.new,
        do: {px,py}
  end

  def combine(acc, next), do: Map.merge(acc, next, fn _k, v1, v2 -> v1 ++ v2 end)

  def find([h|t]), do: find(h, t, Map.new(t), [h|t])
  def find({id, _}, [], _, _), do: id
  def find({id, ar}, [{oid, _}|t], r, a) when id == oid, do: find({id, ar}, t, r, a)
  def find({id, area}, [{oid, oarea}|t], rem, all) do
    case MapSet.intersection(area, oarea) |> MapSet.to_list do
      [] -> find({id, area}, t, rem, all)
      _  -> next(rem, all, id, oid)
    end
  end

  defp next(rem, all, del1, del2) do
    still = rem |> Map.delete(del1) |> Map.delete(del2)
    next = still |> Map.keys |> hd
    find({next, Map.get(still, next)}, all, still, all)
  end
end

lines = File.stream!("input")
  |> Stream.map(&String.trim_trailing/1)
  |> Stream.map(&(String.split(&1, ["#"," ","@",",","x",":"])))
  |> Stream.map(&(&1 |> Enum.map(fn "" -> ""
                                    n  -> String.to_integer(n) end)))

lines
  |> Stream.map(&Day03.pointmap/1)
  |> Enum.reduce(&Day03.combine/2) 
  |> Map.values
  |> Enum.map(&Enum.count/1)
  |> Enum.filter(&(&1 > 1)) 
  |> Enum.count
  |> IO.puts

lines
  |> Enum.map(&Day03.idarea/1)
  |> Day03.find
  |> IO.puts

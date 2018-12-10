defmodule Day10 do
  def cycle(map, count \\ 1)  
  def cycle(_, 20_000), do: :nok
  def cycle(map, count) do
    pts = move(map, count) |> Enum.sort
    case print(pts, count) do
      :cont -> cycle(map, count + 1)
      :done -> :ok
    end
  end

  defp print(points, seconds) do
    {xs, ys} = grid(points)
    if Enum.count(ys) <= 10 do
      print(xs, xs, ys, ys, "", points)
      IO.puts("#{seconds}\n")
      :done
    else
      :cont
    end
  end

  defp grid(points) do
    xs = points |> Enum.map(fn {x, _} -> x end)
    min_x = xs |> Enum.min
    max_x = xs |> Enum.max
    ys = points |> Enum.map(fn {_, y} -> y end)
    min_y = ys |> Enum.min
    max_y = ys |> Enum.max
    {min_x..max_x |> Enum.to_list, min_y..max_y |> Enum.to_list}
  end

  defp print(_, _, [], _, _, _), do: :ok
  defp print([], xs, [_|yt], ys, acc, pts) do
    IO.puts acc
    print(xs, xs, yt, ys, "", pts)
  end
  defp print([xh|xt], xs, [yh|yt], ys, acc, pts) do
    str = case {xh,yh} in pts do
      true -> "#"
      false -> "."
    end
    print(xt, xs, [yh|yt], ys, acc <> str, pts)
  end

  defp move(map, count) do
    map
    |> Map.to_list
    |> Enum.map(fn {{x,y}, {dx,dy}} -> {x+dx*count,y+dy*count} end)
  end

  def int(str) do
    str |> String.trim |> String.to_integer
  end
end

File.stream!("input")
  |> Stream.map(&String.trim_trailing/1)
  |> Stream.map(&(String.split(&1, ["<", ",", ">"])))
  |> Enum.map(fn [_, x, y, _, dx, dy|_] -> {{Day10.int(x),Day10.int(y)},{Day10.int(dx),Day10.int(dy)}} end)
  |> Map.new
  |> Day10.cycle

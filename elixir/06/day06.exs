defmodule Day06 do
  def area(l) do
    xs = l |> Enum.map(fn {x, _} -> x end)
    ys = l |> Enum.map(fn {_, y} -> y end)
    {Enum.min(xs) - 2, Enum.max(xs) + 2, Enum.min(xs) - 2, Enum.max(ys) + 2}
  end

  def calc(l, area) do
    closest(grid(area), l)
  end

  def part1(l, area) do
    Enum.reduce(l, %{}, fn item, acc -> count(item, acc, area) end)
      |> Map.values
      |> Enum.filter(fn 
          {_, :finite} -> true 
          _ -> false 
        end)
      |> Enum.map(fn {count, _} -> count end)
      |> Enum.max
  end

  def part2(l) do
    l |> Enum.filter(fn {_, _ , within} -> within end) |> Enum.count
  end

  defp grid({min_x, max_x, min_y, max_y}) do
    for x <- min_x..max_x,
        y <- min_y..max_y,
        do: {x,y}
  end

  defp closest(grid, pts), do: closest(grid, nil, nil, :neq, [], pts, 0)
  defp closest([], _, _, _, acc, _, _), do: acc
  defp closest([gh|gt], [], _, :eq, acc, pts, dist), do: closest(gt, nil, nil, :neq, [{gh, nil, dist < 10000}|acc], pts, 0)
  defp closest([gh|gt], [], p, :neq, acc, pts, dist), do: closest(gt, nil, nil, :neq, [{gh, p, dist < 10000}|acc], pts, 0)
  defp closest([gh|gt], nil, nil, :neq, acc, [ph|pt], 0), do: closest([gh|gt], pt, ph, :neq, acc, [ph|pt], dist(ph,gh))
  defp closest([gh|gt], [ph|pt], p, eq, acc, pts, dist) do
    dp = dist(p,gh)
    dph = dist(ph,gh)
    case dp - dph do
      0 -> closest([gh|gt], pt, p, :eq, acc, pts, dist + dph)
      x when x < 0 -> closest([gh|gt], pt, p, eq, acc, pts, dist + dph)
      x when x > 0 -> closest([gh|gt], pt, ph, :neq, acc, pts, dist + dph)
    end 
  end
  
  defp dist({x1,y1}, {x2,y2}), do: abs(x1-x2) + abs(y1-y2)

  defp count({{x,y}, point, _}, acc, {min_x, max_x, min_y, max_y}) do
    {count, finity} = Map.get(acc, point, {0, :finite})
    case x == min_x || x == max_x || y == min_y || y == max_y do
      true -> Map.put(acc, point, {count, :infinite})
      false -> Map.put(acc, point, {count + 1, finity})
    end
  end
end

coords = File.stream!("input")
  |> Stream.map(&String.trim_trailing/1)
  |> Stream.map(&(String.split(&1, ", ")))
  |> Enum.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)
area = Day06.area(coords)
grid = Day06.calc(coords, area)

grid |> Day06.part1(area) |> IO.puts
grid |> Day06.part2 |> IO.puts
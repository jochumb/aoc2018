defmodule Day03 do

  def parse([_, _, dist, size]) do
    [x, y] = parse_dist(dist)
    [a, b] = parse_size(size)
    for s <- x+1..x+a,
        t <- y+1..y+b,
        into: %{},
        do: {{s,t}, 1}
  end

  def parse_dist(dist), do: dist |> String.trim(":") |> String.split(",") |> Enum.map(&String.to_integer/1)
  def parse_size(size), do: size |> String.split("x") |> Enum.map(&String.to_integer/1)

  def combine(acc, next), do: Map.merge(acc, next, fn _k, v1, v2 -> v1 + v2 end)

  def count(map), do: map |> Map.values |> Enum.filter(&(&1 > 1)) |> Enum.count

  def parse2([id, _, dist, size]) do
    [x, y] = parse_dist(dist)
    [a, b] = parse_size(size)
    for s <- x+1..x+a,
        t <- y+1..y+b,
        into: %{},
        do: {{s,t}, String.trim(id, "#")}
  end

  def find([h|t]), do: find(h, t, t, [h|t])
  def find(c, [], _, _), do: c |> Map.values |> hd
  def find(c, [h|t], l, o) do
    id = c |> Map.values |> hd
    other = h |> Map.values |> hd
    if String.equivalent?(id, other) do
      find(c, t, l, o)
    else
      count = c |> Map.values |> Enum.count
      dropcount = c
        |> Map.drop(Map.keys(h))
        |> Map.values
        |> Enum.count
      if dropcount == count do
        find(c, t, l, o)
      else
        find(l |> hd, o, l |> tl, o)
      end
    end
  end
end

list = File.stream!("input")
  |> Stream.map(&String.trim_trailing/1)

list 
  |> Stream.map(&String.split/1) 
  |> Stream.map(&Day03.parse/1) 
  |> Enum.reduce(&Day03.combine/2)
  |> Day03.count
  |> IO.puts

list 
  |> Stream.map(&String.split/1) 
  |> Enum.map(&Day03.parse2/1) 
  |> Day03.find
  |> IO.puts
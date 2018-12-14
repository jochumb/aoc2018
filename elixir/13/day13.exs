defmodule Day13 do
  def parse([h|t]), do: parse(h, t, 0, 0, %{}, %{})
  def parse([], [], _, _, map, carts), do: {map, carts}
  def parse([], [h|t], _, y, map, carts), do: parse(h, t, 0, y+1, map, carts)
  def parse([h|t], r, x, y, map, carts) do
    case h do
      " "  -> parse(t, r, x+1, y, map, carts)
      "|"  -> parse(t, r, x+1, y, Map.put(map, {x,y}, :ns), carts)
      "-"  -> parse(t, r, x+1, y, Map.put(map, {x,y}, :ew), carts)
      "+"  -> parse(t, r, x+1, y, Map.put(map, {x,y}, :all), carts)
      "/"  -> parse(t, r, x+1, y, Map.put(map, {x,y}, :senw), carts)
      "\\" -> parse(t, r, x+1, y, Map.put(map, {x,y}, :swne), carts)
      "^"  -> parse(t, r, x+1, y, Map.put(map, {x,y}, :ns), Map.put(carts, {x,y}, {:up, :none}))
      "v"  -> parse(t, r, x+1, y, Map.put(map, {x,y}, :ns), Map.put(carts, {x,y}, {:down, :none}))
      ">"  -> parse(t, r, x+1, y, Map.put(map, {x,y}, :ew), Map.put(carts, {x,y}, {:right, :none}))
      "<"  -> parse(t, r, x+1, y, Map.put(map, {x,y}, :ew), Map.put(carts, {x,y}, {:left, :none}))
    end
  end

  def iterate({map, carts}, crash?) do
    queue = carts |> Map.keys |> Enum.sort(fn {x1,y1}, {x2,y2} -> y1 + x1/1000 < y2 + x2/1000 end)
    iterate(queue, {map, carts}, crash?)
  end

  def iterate([], {map, carts}, _), do: {map, carts}
  def iterate([h|t], {map, carts}, crash?) do
    {nextpos, nextval} = nextpos(h, Map.get(carts, h), map)
    case {Map.get(carts, nextpos, :none), crash?} do
      {:none, _} -> iterate(t, {map, carts |> Map.delete(h) |> Map.put(nextpos, nextval)}, crash?)
      {_, true}  -> {:crash, nextpos}
      {_, false} -> iterate(List.delete(t, nextpos), {map, carts |> Map.delete(h) |> Map.delete(nextpos)}, crash?)
    end
  end

  def nextpos({x,y}, {direction, lastcorner}, map) do
    {nextpos, type} = case direction do
      :up    -> lookup(map, {x,y-1})
      :down  -> lookup(map, {x,y+1})
      :left  -> lookup(map, {x-1,y})
      :right -> lookup(map, {x+1,y})
    end
    nextdir = case {type,direction,lastcorner} do
      {:ns,d,l}        -> {d,l} 
      {:ew,d,l}        -> {d,l}
      {:all,d,l}       -> corner(d,l)
      {:senw,:up,l}    -> {:right,l}
      {:senw,:down,l}  -> {:left,l}
      {:senw,:left,l}  -> {:down,l}
      {:senw,:right,l} -> {:up,l}
      {:swne,:up,l}    -> {:left,l}
      {:swne,:down,l}  -> {:right,l}
      {:swne,:left,l}  -> {:up,l}
      {:swne,:right,l} -> {:down,l}
    end
    {nextpos, nextdir}
  end

  def lookup(map, pos), do: {pos, Map.get(map, pos)}

  def corner(direction, :left),  do: {direction, :straight}
  def corner(:up, :straight),    do: {:right, :right}
  def corner(:down, :straight),  do: {:left, :right}
  def corner(:left, :straight),  do: {:up, :right}
  def corner(:right, :straight), do: {:down, :right}
  def corner(:up, _),            do: {:left, :left}
  def corner(:down, _),          do: {:right, :left}
  def corner(:left, _),          do: {:down, :left}
  def corner(:right, _),         do: {:up, :left}
end


{map, carts} = File.stream!("input") 
  |> Stream.map(&String.trim_trailing/1)
  |> Enum.map(&(String.split(&1, "", trim: true)))
  |> Day13.parse

0..100_000 |> Enum.reduce_while({map, carts},
  fn _, acc ->
    case Day13.iterate(acc, true) do
      {:crash, {x,y}} -> {:halt, "#{x},#{y}"}
      acc             -> {:cont, acc}
    end
  end)
  |> IO.puts

0..100_000 |> Enum.reduce_while({map, carts},
  fn _, acc ->
    {nm, nc} = Day13.iterate(acc, false)
    case nc |> Map.keys do
      [{x,y}|[]] -> {:halt, "#{x},#{y}"}
      _          -> {:cont, {nm,nc}}
    end
  end)
  |> IO.puts

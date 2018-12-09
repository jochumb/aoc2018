defmodule Day04 do
  def parse([d, t, _, id | _]) do
    pd = d |> String.trim("[") |> String.replace("-", "") |> String.to_integer
    pt = t |> String.trim("]") |> String.replace(":", "") |> String.to_integer
    dt = {pd, pt}
    case id do
      "asleep" -> {dt, :start}
      "up" -> {dt, :end}
      "#" <> num -> {dt, String.to_integer(num)}
    end
  end

  def time_asleep(l, acc \\ %{}, cur \\ 0, start \\ 0)
  def time_asleep([], acc, _, _), do: acc
  def time_asleep([{{_,dt},:start}|t], acc, cur, _) do
    time_asleep(t, acc, cur, dt)
  end
  def time_asleep([{{_,dt},:end}|t], acc, cur, start) do
    nap_time = start..dt-1
    new_acc = Map.update(acc, cur, [nap_time], &([nap_time|&1]))
    time_asleep(t, new_acc, cur, dt)
  end
  def time_asleep([{{_,dt},id}|t], acc, _, _) do
    time_asleep(t, acc, id, dt)
  end

  def minutes_used({id, rs}) do
    mincount = rs
      |> Enum.map(fn r -> r |> Map.new(fn x -> {x, 1} end) end)
      |> Enum.reduce(fn acc, n -> Map.merge(acc, n, fn _k, v1, v2 -> v1 + v2 end) end)
      |> Map.to_list
      |> Enum.sort(fn {_, x}, {_, y} -> x >= y end)
    {id, mincount}
  end

  def calc_part1({id, rs}) do
    {min, _count} = rs
      |> Enum.map(fn r -> r |> Map.new(fn x -> {x, 1} end) end)
      |> Enum.reduce(fn acc, n -> Map.merge(acc, n, fn _k, v1, v2 -> v1 + v2 end) end)
      |> Map.to_list
      |> Enum.sort(fn {_, x}, {_, y} -> x >= y end)
      |> hd
    id * min
  end

  def calc_part2({id, ms}) do
    {min, _count} = ms |> hd
    id * min
  end

end


parsed = File.stream!("input")
  |> Stream.map(&String.trim_trailing/1)
  |> Stream.map(&String.split/1)
  |> Enum.map(&Day04.parse/1)
  |> List.keysort(0)
  |> Day04.time_asleep
  |> Map.to_list

parsed
  |> Enum.sort_by(fn {_k, v} -> v |> Enum.map(fn f..l -> l-f end) |> Enum.sum end)
  |> Enum.reverse
  |> hd
  |> Day04.calc_part1
  |> IO.puts

parsed
  |> Enum.map(&Day04.minutes_used/1)
  |> Enum.sort_by(fn {_k, v} -> v |> Enum.map(fn {_, c} -> c end) |> hd end)
  |> Enum.reverse
  |> hd
  |> Day04.calc_part2
  |> IO.puts
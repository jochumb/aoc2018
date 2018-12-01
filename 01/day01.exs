defmodule Day01 do
  def cycle(list), do: cycle(list, list, 0, MapSet.new([0]))
  def cycle([], orig, acc, seen), do: cycle(orig, orig, acc, seen)
  def cycle([h|t], orig, acc, seen) do
    next = acc + h
    case MapSet.member?(seen, next) do 
      true -> next
      _    -> cycle(t, orig, next, MapSet.put(seen, next))
    end
  end
end

list = File.stream!("input")
  |> Stream.map(&String.trim_trailing/1)
  |> Enum.map(&String.to_integer/1)

list |> Enum.sum |> IO.puts
list |> Day01.cycle |> IO.puts

defmodule Day01 do
  def sum(list, acc \\ 0)
  def sum([], acc), do: acc
  def sum([h|t], acc) do
    {op, num} = parse(h)
    sum(t, op.(acc, num))
  end

  def cycle(list), do: cycle(list, list, 0, %{0 => true})
  def cycle([], orig, acc, seen), do: cycle(orig, orig, acc, seen)
  def cycle([h|t], orig, acc, seen) do
    {op, num} = parse(h)
    next = op.(acc, num)
    case seen[next] do
      nil -> cycle(t, orig, next, Map.put(seen, next, true))
      _ -> next
    end
  end

  def parse("-" <> n), do: {&Kernel.-/2, String.to_integer(n)}
  def parse("+" <> n), do: {&Kernel.+/2, String.to_integer(n)}
end

{:ok, file} = File.open("input", [:read])
list = file
  |> IO.stream(:line)
  |> Enum.map(&String.trim_trailing/1)
File.close(file)

list |> Day01.sum |> IO.puts
list |> Day01.cycle |> IO.puts


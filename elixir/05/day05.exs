import String
import Kernel, except: [length: 1]

defmodule Day05 do

  def abc(), do: "abcdefghijklmnopqrstuvwxyz" |> graphemes

  def scan(str) do
    newstr = abc() |> Enum.reduce(str, fn c, acc -> remove_pair(acc, c) end)
    length = length(newstr)
    if (length(str) == length), do: length, else: scan(newstr)
  end

  defp remove_pair(str, c) do
    str |> replace(c <> upcase(c), "") |> replace(upcase(c) <> c, "") 
  end

  def remove_of_type(str, type) do
    str |> replace(type, "") |> replace(upcase(type), "")
  end
end

input = File.stream!("input")
  |> Enum.map(&String.trim_trailing/1)
  |> hd

input
  |> Day05.scan
  |> IO.puts

Day05.abc
  |> Stream.map(&(Day05.remove_of_type(input, &1)))
  |> Stream.map(&Day05.scan/1)
  |> Enum.min
  |> IO.puts

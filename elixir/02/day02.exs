import Enum
import String
import Kernel, except: [length: 1]

defmodule Day02 do
  def checksum(list, two \\ 0, three \\ 0)
  def checksum([], two, three), do: two * three
  def checksum([h|t], two, three) do
    cl = h |> graphemes |> sort |> chunk_by(&(&1))
    checksum(t, two + of_length?(cl, 2), three + of_length?(cl, 3))
  end

  defp of_length?(chars, length) do
    if chars |> filter(&(count(&1) == length)) |> empty?, do: 0, else: 1
  end

  def fabric_boxes([h|t]), do: fabric_boxes(h, t, t)
  defp fabric_boxes(_, [], [h|t]), do: fabric_boxes(h, t, t)
  defp fabric_boxes(s, [h|t], o) do
    case match(s, h) do
      {:ok, res} -> res
      _ ->  fabric_boxes(s, t, o)
    end
  end

  defp match(s1, s2) do
    res = myers_difference(s1, s2) |> Keyword.get_values(:eq) |> join
    case length(s1) - length(res) do
      1 -> {:ok, res}
      _ -> :nok
    end
  end
end

list = File.stream!("input") |> Enum.map(&String.trim_trailing/1)

list |> Day02.checksum |> IO.puts
list |> Day02.fabric_boxes |> IO.puts
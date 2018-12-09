defmodule Day08 do
  def metadata(l, c \\ 1, m \\ 0, i \\ 1, vs \\ %{})
  def metadata([], _, _, _, _), do: {[], 0, 0}
  def metadata(l, 0, m, i, vs) do
    {meta, rem} = l |> Enum.split(m)
    sum = Enum.sum(meta)
    case i do
      1 -> {rem, sum, sum}
      _ -> {rem, sum, value(meta, vs)}
    end
  end
  def metadata([f,s|t], c, m, i, vs) do
    case metadata(t, f, s) do
      {[], sum, value}  -> {[], sum, value}
      {rem, sum, value} -> plus(sum, metadata(rem, c-1, m, i+1, Map.put(vs, i, value)))
    end
  end

  defp plus(sum, {rem, sum_add, value}), do: {rem, sum+sum_add, value}

  defp value(meta, ref, acc \\ 0)
  defp value([], _, acc), do: acc
  defp value([h|t], ref, acc), do: value(t, ref, acc + Map.get(ref, h, 0))
end

metadata = File.stream!("input")
  |> Enum.map(&String.trim_trailing/1)
  |> hd
  |> String.split
  |> Enum.map(&String.to_integer/1)
  |> Day08.metadata

metadata |> elem(1) |> IO.inspect
metadata |> elem(2) |> IO.inspect
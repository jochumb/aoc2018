defmodule Day09 do

  def play(players, marbles), do: 2..marbles |> Enum.to_list |> play([0], [1], 2, players, %{})
  def play([], _, _, _, _, score), do: score |> Map.values |> Enum.max
  def play([m|ms], cf, cb, player, ps, score) when rem(m, 23) == 0 do
    {ncf, [pts|ncb]} = rotate(cf, cb, -7)
    next_s = Map.update(score, player, m + pts, &(&1 + m + pts))
    play(ms, ncf, ncb, mod(player + 1, ps), ps, next_s)
  end
  def play([m|ms], cf, cb, player, ps, score) do
    {ncf, ncb} = rotate(cf, cb, 2)
    play(ms, ncf, [m|ncb], mod(player + 1, ps), ps, score)
  end

  def rotate(cf, cb, 0), do: {cf, cb}
  def rotate(cf, [], count) when count > 0 do
    cb = Enum.reverse(cf)
    rotate([hd(cb)], tl(cb), count - 1)
  end
  def rotate(cf, [bh|bt], count) when count > 0 do
    rotate([bh|cf], bt, count - 1)
  end
  def rotate([], cb, count) when count < 0 do
    cf = Enum.reverse(cb)
    rotate(tl(cf), [hd(cf)], count + 1)
  end
  def rotate([fh|ft], cb, count) when count < 0 do
    rotate(ft, [fh|cb], count + 1)
  end
   
  def mod(n, m) do
    case rem(n+m, m) do
      0 -> m
      x -> x
    end
  end 
  
end

{players, marbles} = File.stream!("input")
  |> Enum.map(&String.trim_trailing/1)
  |> hd
  |> String.split
  |> fn [p, _, _, _, _, _, m|_] -> {String.to_integer(p), String.to_integer(m)} end.()

Day09.play(players, marbles) |> IO.puts
Day09.play(players, marbles * 100) |> IO.puts

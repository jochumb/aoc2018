defmodule Day11 do
  
  def grid(serial) do
    for x <- 1..300,
        y <- 1..300,
        into: %{},
        do: {{x,y}, val(x,y,serial)}
  end

  defp val(x,y,serial) do
    ((x+10)*y+serial)*(x+10)
      |> Integer.digits
      |> Enum.reverse
      |> Enum.drop(2)
      |> hd
      |> Kernel.-(5)
  end 

  def sum(map, count) do
    for x <- 1..300-count+1,
        y <- 1..300-count+1,
        into: %{},
        do: {{x,y}, sum({x,y}, map, count)}
  end

  defp sum({x,y}, map, count) do
    vals = for xk <- x..x+count-1,
               yk <- y..y+count-1,
               do: Map.get(map, {xk,yk}, 0)
    Enum.sum(vals)
  end

  def max(map) do
    map |> Map.to_list |> Enum.max_by(fn {_, val} -> val end)
  end

end

serial = System.argv() |> fn 
    [] -> ["8444"]
    args -> args
  end.() |> hd |> String.to_integer
grid = Day11.grid(serial)

grid |> Day11.sum(3) |> Day11.max |> fn {{x,y},_} -> "#{x},#{y}" end.() |> IO.puts

3..20 #probably fine
  |> Enum.map(&(Task.async(fn -> {&1, grid |> Day11.sum(&1) |> Day11.max} end)))
  |> Enum.map(&Task.await/1)
  |> Enum.max_by(fn {_,{ _, val}} -> val end)
  |> fn {n,{{x,y},_}} -> "#{x},#{y},#{n}" end.() 
  |> IO.puts

defmodule Day07 do
  def dependency_map(l, acc \\ %{})
  def dependency_map([], acc), do: Map.to_list(acc)
  def dependency_map([{k, v}|t], acc) do
    deps = for d <- v, into: %{k => []}, do: {d, [k]}
    new_acc = Map.merge(acc, deps, fn _k, v1, v2 -> v1 ++ v2 end)
    dependency_map(t, new_acc)
  end

  def order(deps, acc \\ [])
  def order([], acc), do: Enum.reverse(acc)
  def order(deps, acc) do
    next = no_deps_left(deps) |> hd
    next |> remove(deps) |> order([next|acc])
  end

  defp no_deps_left(deps) do
    deps 
    |> Enum.reduce([], 
        fn {l, []}, acc -> [l|acc]
                  _, acc -> acc
        end)
    |> Enum.sort
  end

  defp remove(dep, deps) do
    deps 
    |> Enum.filter(fn {k,_} -> k != dep end) 
    |> Enum.map(fn {k, v} -> {k, v -- [dep]} end)
  end

  def process(deps, seconds \\ 0, done \\ [], agents \\ [:ok,:ok,:ok,:ok,:ok])
  def process([], seconds, _, [:ok,:ok,:ok,:ok,:ok]) when seconds != 0, do: seconds
  def process(deps, seconds, done, agents) do
    {new_done, new_agents} = agents_done(agents, seconds)
    case new_done do
      [] -> next(deps, seconds, done, Enum.sort(agents))
      _  -> process(deps, seconds, done ++ new_done, new_agents)
    end
  end

  defp agents_done(agents, seconds) do
    done = agents
      |> Enum.filter(fn x -> x != :ok end)
      |> Enum.filter(fn {s,_} -> s == seconds end) 
      |> Enum.map(fn {_,i} -> i end)
    new_agents = agents |> Enum.map(fn 
        {s,i} -> if s == seconds, do: :ok, else: {s,i} 
        x -> x
      end)
    {done, new_agents}
  end

  defp next(deps, seconds, done, [:ok|agents]) do
    new_deps = done |> Enum.reduce(deps, fn d, acc -> remove(d, acc) end)
    next = no_deps_left(new_deps)
    case next do
      [] -> process(deps, seconds + 1, done, [:ok|agents])
      [h|_] -> process(Enum.filter(new_deps, fn {k,_} -> k != h end), seconds, done, [{seconds + time(h), h}|agents])
    end
  end
  defp next(deps, seconds, done, agents), do: process(deps, seconds + 1, done, agents)

  defp time(str), do: String.to_charlist(str) |> hd |> fn c -> c - ?A + 61 end.()
end

deps = File.stream!("input")
  |> Stream.map(&String.trim_trailing/1)
  |> Stream.map(&String.split/1)
  |> Stream.map(fn [_, a, _, _, _, _, _, b|_] -> {a,b} end)
  |> Enum.reduce(%{}, fn {a, b}, acc -> Map.update(acc, a, [b], &([b|&1] |> Enum.sort)) end)
  |> Map.to_list
  |> Day07.dependency_map

deps |> Day07.order |> Enum.join |> IO.puts
deps |> Day07.process |> IO.puts
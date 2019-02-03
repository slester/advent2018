defmodule Advent2018.Day1 do
  defmodule Part1 do
    def execute(input) do
      input
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
      |> Integer.to_string()
    end
  end

  defmodule Part2 do
    def execute(input) do
      freq_changes = input |> Enum.map(&String.to_integer/1)
      seen_freqs = MapSet.new([0])
      find_repetition(freq_changes, 0, seen_freqs)
      |> Integer.to_string()
    end

    defp find_repetition(freq_changes, current_freq, seen_freqs) do
      [change | rest_changes] = freq_changes
      new_freq = current_freq + change
      if MapSet.member?(seen_freqs, new_freq) do
        new_freq
      else
        find_repetition(
          rest_changes ++ [change],
          new_freq,
          MapSet.put(seen_freqs, new_freq)
        )
      end
    end
  end
end

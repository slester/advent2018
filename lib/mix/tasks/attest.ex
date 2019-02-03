ExUnit.start()

defmodule Mix.Tasks.Attest do
  use Mix.Task
  require Logger
  use ExUnit.Case

  @shortdoc "Run tests of a particular part for a given day."
  def run([day, part]) do
    tests = Path.wildcard("priv/day#{day}/part#{part}/ex*.txt")
    # Run all the tests to see if we should run the actual input.
    tests
    |> Enum.map(&parse_example/1)
    |> Enum.map(fn %{input: input, output: output} -> run_example(day, part, input, output) end)

    # Run the actual input.
    {:ok, input_data} = File.read("priv/day#{day}/input.txt")
    execute(day, part, String.split(input_data, "\n", trim: true))
    |> IO.inspect(label: "Day #{day}, Part #{part} Results")
  end

  @shortdoc "Run both tests for a given day."
  def run([day]) do
    run([day, 1])
    run([day, 2])
  end

  defp parse_example(file) do
    {:ok, file_data}= File.read(file)
    [input, output] = file_data
                      |> String.split("\n", trim: true)
    input = input
            |> String.split(",", trim: true)
            |> Enum.map(&String.trim/1)
    %{input: input,
      output: output}
  end

  defp run_example(day, part, input, output) do
    IO.puts("Running day #{day}, part #{part}, with: #{Enum.join(input, ", ")}")
    assert execute(day, part, input) == output
  end

  defp execute(day, part, input) do
    module = Advent2018
             |> Module.concat("Day#{day}")
             |> Module.concat("Part#{part}")
    apply(module, :execute, [input])
  end
end

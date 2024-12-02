defmodule DataParser do
    def parse_file(filename) do
      File.stream!(filename)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split(&1, ~r/\s+/))

      |> Enum.zip()
    end
  end

# Obtain lists of each column from file and sort them
[sorted_left, sorted_right] = DataParser.parse_file("1.1.input")
|> Enum.map(&Tuple.to_list/1)
|> Enum.map(&Enum.sort/1)

differences = Enum.zip(sorted_left, sorted_right)
|> Enum.map(fn {l, r} -> abs(String.to_integer(l) - String.to_integer(r)) end)

sum_differences = Enum.sum(differences)

IO.inspect(sum_differences)

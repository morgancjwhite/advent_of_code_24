defmodule DataParser do
  def parse_file(filename) do
    File.stream!(filename)
    |> Enum.map(&String.trim/1)
    |> Enum.join()
  end
end

data = DataParser.parse_file("3.input")

sum =
  # Look for mul(NUM,NUM) pattern and capture both numbers
  Regex.scan(~r/mul\((?<x>[0-9]+),(?<y>[0-9]+)\)/, data)
  # Unpack matches and multiply
  |> Enum.map(fn [_, x, y] -> String.to_integer(x) * String.to_integer(y) end)
  |> Enum.sum()

IO.inspect(sum)

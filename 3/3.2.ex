defmodule DataParser do
  def parse_file(filename) do
    File.stream!(filename)
    |> Enum.map(&String.trim/1)
    |> Enum.join()
  end
end

data = DataParser.parse_file("3.input")

# Look for do(), don't() and mul(NUM,NUM) patterns and capture them both numbers
sum =
  Regex.scan(~r/do\(\)|don\'t\(\)|mul\((?<x>[0-9]+),(?<y>[0-9]+)\)/, data)
  |> Enum.reduce(0, fn match, acc ->
    # Use accumulator sign to encode info as to whether we should add or not
    case match do
      ["do()"] ->
        abs(acc)

      ["don't()"] ->
        -abs(acc)

      [_, x, y] ->
        if acc >= 0 do
          # Only add product if accumulator is positive, i.e. we are in the "do()" state
          acc + String.to_integer(x) * String.to_integer(y)
        else
          acc
        end
    end
  end)
  |> abs

IO.inspect(sum)

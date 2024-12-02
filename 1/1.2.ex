defmodule DataParser do
  def parse_file(filename) do
    File.stream!(filename)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ~r/\s+/))
    |> Enum.zip()
  end
end

# Obtain lists of each column from file
[left, right] =
  DataParser.parse_file("1.input")
  |> Enum.map(&Tuple.to_list/1)

# Store count of each element in right list in a map
# First thing is the reduce on the right list, starting with an empty map %{}
# An element from each list and the accumlating map gets passed into an anonymous function
# that updates the map with the value 1 if it exists or defaults to 1
# Amounts to a select num, count(num) from _ group by num...
similarity_map =
  Enum.reduce(right, %{}, fn r, acc ->
    Map.update(acc, r, 1, fn value -> value + 1 end)
  end)

# Multiply each element in left list by count in right list
# Sum the result
similarity_score =
  Enum.map(left, fn l ->
    String.to_integer(l) * Map.get(similarity_map, l, 0)
  end)
  |> Enum.sum()

IO.inspect(similarity_score)

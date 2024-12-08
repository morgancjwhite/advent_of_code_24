defmodule DataParser do
  def parse_file(filename) do
    File.stream!(filename)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ~r/\s+/))
  end
end

reports =
  Enum.map(DataParser.parse_file("2.input"), fn l -> Enum.map(l, &String.to_integer/1) end)

defmodule SafeReportCheck do
  def ascending_or_descending(report) do
    sorted_report = Enum.sort(report)
    # Check to see if sorted list is the list (ascending)
    # or the reversed sorted list is the list (descending)
    # This doesn't account for a difference of zero, but the other check will
    sorted_report == report or Enum.reverse(sorted_report) == report
  end

  def level_differ_within_1_to_3(report) do
    diff_list =
      Enum.zip(report, tl(report))
      |> Enum.map(fn {x, y} -> abs(y - x) end)

    1 <= Enum.min(diff_list) and Enum.max(diff_list) <= 3
  end
end

safe_cond_1 = Enum.map(reports, &SafeReportCheck.ascending_or_descending/1)
safe_cond_2 = Enum.map(reports, &SafeReportCheck.level_differ_within_1_to_3/1)

safe_count =
  Enum.zip(safe_cond_1, safe_cond_2)
  |> Enum.count(fn {x, y} -> x and y end)

IO.inspect(safe_count)

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

  def check_report_dampened(report) do
    Enum.map(0..(length(report) - 1), fn index ->
      List.delete_at(report, index)
    end)
    |> Enum.map(fn r -> ascending_or_descending(r) and level_differ_within_1_to_3(r) end)
    |> Enum.any?()
  end
end

dampened_safe_count = Enum.map(reports, &SafeReportCheck.check_report_dampened/1)
|> Enum.count(fn a -> a == true end)
IO.inspect(dampened_safe_count)

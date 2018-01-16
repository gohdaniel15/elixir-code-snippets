defmodule TextAnalyser do

  def analyse_file(file_name),
  do: File.read!(file_name) |> analyse

  def analyse(data) do
    data
    |> String.replace(~r/[,.]+/, "")
    |> String.split
    |> Enum.chunk_every(10000)
    |> Enum.map(fn(sub_arr) ->
      Task.async(TextAnalyser, :word_count_map, [sub_arr])
    end)
    |> Enum.map(&Task.await(&1))
    |> merge_word_count_map
    # |> Enum.reduce(%{}, fn(letter, acc) ->
    #   Map.update(acc, letter, 1, &(&1 + 1))
    # end
  end

  def word_count_map(word_list) do
    word_list
    |> Enum.reduce(%{}, fn(letter, acc) ->
      Map.update(acc, letter, 1, &(&1 + 1))
    end)
  end

  def merge_word_count_map([first_map | [second_map | tail]]) do
    merged_map = Map.merge(first_map, second_map, fn _k, v1, v2 ->
      v1 + v2
    end)
    merge_word_count_map([merged_map | tail])
  end

  def merge_word_count_map([first_map]), do: first_map
  def merge_word_count_map([]), do: Map.new

end

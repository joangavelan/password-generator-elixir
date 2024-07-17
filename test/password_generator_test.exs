defmodule PasswordGeneratorTest do
  use ExUnit.Case

  setup do
    length = 5

    character_sets = %{
      lowercase: Enum.map(?a..?z, & &1),
      numbers: Enum.map(?0..?9, & &1),
      uppercase: Enum.map(?A..?Z, & &1),
      symbols: ~c"!#$%&()*+,-./:;<=>?@[]^_{|}~"
    }

    %{
      length: length,
      character_sets: character_sets
    }
  end

  test "should have the given length", context do
    {:ok, password} = PasswordGenerator.generate(context.length)

    assert String.length(password) == context.length
  end

  test "should contain only lowercase letters when no options are provided", context do
    {:ok, password} = PasswordGenerator.generate(context.length)

    assert password |> to_charlist |> Enum.all?(&(&1 in context.character_sets.lowercase))
  end

  test "should contain characters enabled by options", context do
    opts = [uppercase: true, numbers: true, symbols: false]

    {:ok, password} = PasswordGenerator.generate(context.length, opts)

    combined_set = PasswordGenerator.get_combined_character_set(context.character_sets, opts)

    assert password |> to_charlist |> Enum.all?(&(&1 in combined_set))
  end
end

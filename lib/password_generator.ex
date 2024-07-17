defmodule PasswordGenerator do
  @moduledoc """
  A module for generating random passwords based on specified options.
  """

  @character_sets %{
    lowercase: Enum.map(?a..?z, & &1),
    numbers: Enum.map(?0..?9, & &1),
    uppercase: Enum.map(?A..?Z, & &1),
    symbols: ~c"!#$%&()*+,-./:;<=>?@[]^_{|}~"
  }

  @type opts() :: [{:uppercase, boolean()} | {:numbers, boolean()} | {:symbols, boolean()}]
  @type character_sets() :: %{
          lowercase: charlist(),
          numbers: charlist(),
          uppercase: charlist(),
          symbols: charlist()
        }

  @doc """
  Generates a random password of the specified length based on the provided options.

  ## Examples

      iex> PasswordGenerator.generate(10, [uppercase: true, numbers: true])
      "aBc1dEfGh2"

  """
  @spec generate(pos_integer(), opts()) :: {:ok, String.t()}
  def generate(length, opts \\ []) when is_integer(length) and length > 0 do
    combined_set = get_combined_character_set(@character_sets, opts)

    password =
      1..length
      |> Enum.map(fn _ -> Enum.random(combined_set) end)
      |> to_string()

    {:ok, password}
  end

  @doc """
  Combines character sets based on the provided options.

  ## Examples

      iex> PasswordGenerator.get_combined_character_set(@character_sets, [uppercase: true, numbers: true])
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

  """
  @spec get_combined_character_set(character_sets(), opts()) :: charlist()
  def get_combined_character_set(character_sets, opts) do
    Enum.reduce(opts, character_sets.lowercase, fn
      {:uppercase, true}, acc -> acc ++ character_sets.uppercase
      {:numbers, true}, acc -> acc ++ character_sets.numbers
      {:symbols, true}, acc -> acc ++ character_sets.symbols
      _, acc -> acc
    end)
  end
end

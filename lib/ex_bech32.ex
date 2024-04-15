defmodule ExBech32 do
  @moduledoc """
  Nif for Bech32 format encoding and decoding.

  It uses https://github.com/rust-bitcoin/rust-bech32 rust library
  """

  alias ExBech32.Impl

  @doc """
  Encodes into Bech32 format appending the version to data

  It accepts the following three paramters:

  - human-readable part
  - witness version
  - data to be encoded
  - bech32 variant. it can be `:bech32` (BIP-0173) or `:bech32m` (BIP-0350)

  ## Examples

      iex> hash = <<155, 40, 145, 113, 34, 76, 127, 94, 72, 185, 33, 104, 237, 9, 209, 84, 242, 199, 72, 211>>
      iex> ExBech32.encode_with_version("bc", 0, hash)
      {:ok, "bc1qnv5fzufzf3l4uj9ey95w6zw32nevwjxn9497vk"}

      iex> ExBech32.encode_with_version("bc", 0, <<1>>)
      {:error, :encode_error}
  """
  @spec encode_with_version(String.t(), non_neg_integer(), binary()) ::
          {:ok, String.t()} | {:error, atom()}
  def encode_with_version(hrp, version, data)

  def encode_with_version(hrp, version, data) do
    Impl.encode_with_version(hrp, version, data)
  end

  @doc """
  Decodes bech32 decoded string with witness version

  ## Examples

      iex> ExBech32.decode_with_version("bc1qnv5fzufzf3l4uj9ey95w6zw32nevwjxn9497vk")
      {:ok, {"bc", 0, <<155, 40, 145, 113, 34, 76, 127, 94, 72, 185, 33, 104, 237, 9, 209, 84, 242, 199, 72, 211>>}}
  """
  @spec decode_with_version(String.t()) ::
          {:ok, {String.t(), non_neg_integer(), binary()}} | {:error, atom()}
  def decode_with_version(encoded) do
    Impl.decode_with_version(encoded)
  end
end

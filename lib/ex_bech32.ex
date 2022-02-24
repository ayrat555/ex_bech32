defmodule ExBech32 do
  @moduledoc """
  Nif for Bech32 format encoding and decoding.

  It uses https://github.com/rust-bitcoin/rust-bech32 rust library
  """

  alias ExBech32.Impl

  @doc """
  Encodes into Bech32 format

  It accepts the following three paramters:

  - human-readable part
  - data to be encoded
  - bech32 variant. it can be `:bech32` (BIP-0173) or `:bech32m` (BIP-0350)

  ## Examples

      iex> ExBech32.encode("bech32", <<0, 1, 2>>)
      {:ok, "bech321qqqsyrhqy2a"}

      iex> ExBech32.encode("bech32m", <<0, 1, 2>>, :bech32m)
      {:ok, "bech32m1qqqsyy9kzpq"}
  """
  @spec encode(String.t(), binary(), atom()) :: {:ok, String.t()} | {:error, atom()}
  def encode(hrp, data, variant \\ :bech32)

  def encode(hrp, data, variant) when variant in [:bech32, :bech32m] do
    Impl.encode(hrp, data, Atom.to_string(variant))
  end

  def encode(_hrp, _data, _variant) do
    {:error, :unknown_variant}
  end

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

      iex> ExBech32.encode_with_version("bc", 0, <<1>>, :bech32k)
      {:error, :unknown_variant}
  """
  @spec encode_with_version(String.t(), non_neg_integer(), binary(), atom()) ::
          {:ok, String.t()} | {:error, atom()}
  def encode_with_version(hrp, version, data, variant \\ :bech32)

  def encode_with_version(hrp, version, data, variant) when variant in [:bech32, :bech32m] do
    Impl.encode_with_version(hrp, version, data, Atom.to_string(variant))
  end

  def encode_with_version(_hrp, _version, _data, _variant) do
    {:error, :unknown_variant}
  end

  @doc """
  Decodes bech32 decoded string

  ## Examples

      iex> ExBech32.decode("bech321qqqsyrhqy2a")
      {:ok, {"bech32", <<0, 1, 2>>, :bech32}}

      iex> ExBech32.decode("bech32m1qqqsyy9kzpq")
      {:ok, {"bech32m", <<0, 1, 2>>, :bech32m}}
  """
  @spec decode(String.t()) :: {:ok, {String.t(), binary(), atom()}} | {:error, atom()}
  def decode(encoded) do
    with {:ok, {hrp, data, variant}} <- Impl.decode(encoded) do
      {:ok, {hrp, data, String.to_atom(variant)}}
    end
  end

  @doc """
  Decodes bech32 decoded string with witness version

  ## Examples

      iex> ExBech32.decode_with_version("bc1qnv5fzufzf3l4uj9ey95w6zw32nevwjxn9497vk")
      {:ok, {"bc", 0, <<155, 40, 145, 113, 34, 76, 127, 94, 72, 185, 33, 104, 237, 9, 209, 84, 242, 199, 72, 211>>, :bech32}}
  """
  @spec decode_with_version(String.t()) ::
          {:ok, {String.t(), non_neg_integer(), binary(), atom()}} | {:error, atom()}
  def decode_with_version(encoded) do
    with {:ok, {hrp, version, data, variant}} <- Impl.decode_with_version(encoded) do
      {:ok, {hrp, version, data, String.to_atom(variant)}}
    end
  end
end

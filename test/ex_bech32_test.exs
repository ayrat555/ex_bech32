defmodule ExBech32Test do
  use ExUnit.Case
  doctest ExBech32

  describe "encode/3" do
    test "fails to encode to unknown bech32 variant" do
      assert {:error, :unknown_variant} == ExBech32.encode("aaa", "mydata", :bech2077)
    end

    test "encodes to bech32" do
      assert {:ok, "aaa1d4ukgct5vylrrvj2"} == ExBech32.encode("aaa", "mydata", :bech32)
    end

    test "encodes to bech32m" do
      assert {:ok, "aaa1d4ukgct5vy2lnqhg"} == ExBech32.encode("aaa", "mydata", :bech32m)
    end
  end

  describe "decode/1" do
    test "decodes bech32" do
      assert {:ok, {"aaa", "mydata", :bech32}} == ExBech32.decode("aaa1d4ukgct5vylrrvj2")
    end

    test "decodes bech32m" do
      assert {:ok, {"aaa", "mydata", :bech32m}} == ExBech32.decode("aaa1d4ukgct5vy2lnqhg")
    end
  end

  describe "encode_with_version/4" do
    test "encodes data with version to bech32" do
      assert {:ok, "aaa1qd4ukgct5vykktzex"} ==
               ExBech32.encode_with_version("aaa", 0, "mydata", :bech32)

      assert {:ok, "aaa1pd4ukgct5vy48rnfa"} ==
               ExBech32.encode_with_version("aaa", 1, "mydata", :bech32)
    end

    test "encodes data with version to bech32m" do
      assert {:ok, "aaa1qd4ukgct5vyr2mwuy"} ==
               ExBech32.encode_with_version("aaa", 0, "mydata", :bech32m)

      assert {:ok, "aaa1pd4ukgct5vyqmnlvl"} ==
               ExBech32.encode_with_version("aaa", 1, "mydata", :bech32m)
    end
  end

  describe "decode_with_version/1" do
    test "decodes data with version to bech32" do
      assert {:ok, {"aaa", 0, "mydata", :bech32}} ==
               ExBech32.decode_with_version("aaa1qd4ukgct5vykktzex")

      assert {:ok, {"aaa", 1, "mydata", :bech32}} ==
               ExBech32.decode_with_version("aaa1pd4ukgct5vy48rnfa")
    end

    test "decodes data with version to bech32m" do
      assert {:ok, {"aaa", 0, "mydata", :bech32m}} ==
               ExBech32.decode_with_version("aaa1qd4ukgct5vyr2mwuy")

      assert {:ok, {"aaa", 1, "mydata", :bech32m}} ==
               ExBech32.decode_with_version("aaa1pd4ukgct5vyqmnlvl")
    end
  end
end

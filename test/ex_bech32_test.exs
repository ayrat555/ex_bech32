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
end

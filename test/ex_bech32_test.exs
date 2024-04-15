defmodule ExBech32Test do
  use ExUnit.Case
  doctest ExBech32

  describe "encode_with_version/4" do
    test "encodes data with version 0" do
      assert {:ok, "bc1q4w46h2at4w46h2at4w46h2at4w46h2at25y74s"} ==
               ExBech32.encode_with_version(
                 "bc",
                 0,
                 <<171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171,
                   171, 171, 171, 171>>
               )
    end

    test "encodes data with version 1" do
      assert {:ok, "bc1p4w46h2at4w46h2at4w46h2at4w46h2at5kreae"} ==
               ExBech32.encode_with_version(
                 "bc",
                 1,
                 <<171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171,
                   171, 171, 171, 171>>
               )
    end

    test "fails to encode" do
      assert {:error, :encode_error} ==
               ExBech32.encode_with_version(
                 "bc",
                 1,
                 <<171>>
               )
    end
  end

  describe "decode_with_version/1" do
    test "decodes data with version 0" do
      assert {
               :ok,
               {
                 "bc",
                 0,
                 <<171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171,
                   171, 171, 171, 171>>
               }
             } ==
               ExBech32.decode_with_version("bc1q4w46h2at4w46h2at4w46h2at4w46h2at25y74s")
    end

    test "decodes data with version 1" do
      assert {
               :ok,
               {
                 "bc",
                 1,
                 <<171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171,
                   171, 171, 171, 171>>
               }
             } ==
               ExBech32.decode_with_version("bc1p4w46h2at4w46h2at4w46h2at4w46h2at5kreae")
    end

    test "fails to decode" do
      assert {:error, :decode_error} ==
               ExBech32.decode_with_version("aaa1qd4ukgct5vyr2mwuy")
    end
  end
end

defmodule ExBech32.Impl do
  @moduledoc false

  use RustlerPrecompiled,
    otp_app: :ex_bech32,
    crate: :exbech32,
    base_url: "https://github.com/ayrat555/ex_bech32/releases/download/v#{version}",
    force_build: System.get_env("EX_BECH32_BUILD") in ["1", "true"],
    version: version

  def encode(_hrp, _data, _variant), do: :erlang.nif_error(:nif_not_loaded)

  def encode_with_version(_hrp, _version, _data, _variant), do: :erlang.nif_error(:nif_not_loaded)

  def decode(_encoded), do: :erlang.nif_error(:nif_not_loaded)

  def decode_with_version(_encoded), do: :erlang.nif_error(:nif_not_loaded)
end

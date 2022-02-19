defmodule ExBech32.Impl do
  use Rustler, otp_app: :ex_bech32, crate: :exbech32

  def encode(_hrp, _data), do: :erlang.nif_error(:nif_not_loaded)

  def decode(_encoded), do: :erlang.nif_error(:nif_not_loaded)
end

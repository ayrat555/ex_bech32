use bech32::u5;
use bech32::ToBase32;
use bech32::Variant;
use rustler::types::binary::Binary;

#[rustler::nif]
fn encode(hrp: String, data: Binary) -> String {
    bech32::encode(&hrp, data.as_slice().to_base32(), Variant::Bech32)
        .unwrap()
        .to_string()
}

#[rustler::nif]
fn decode(encoded: String) -> (String, Vec<u5>, Variant) {
    bech32::decode(&encoded).unwrap()
}

rustler::init!("Elixir.ExBech32.Impl", [encode, decode]);

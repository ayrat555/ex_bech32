use bech32::u5;
use bech32::FromBase32;
use bech32::ToBase32;
use bech32::Variant;
use rustler::Binary;
use rustler::Encoder;
use rustler::Env;
use rustler::OwnedBinary;
use rustler::Term;

mod atoms {
    rustler::atoms! {
        ok,
        error,
        encode_error,
        decode_error,
        invalid_variant
    }
}

#[rustler::nif]
fn encode<'a>(env: Env<'a>, hrp: String, data: Binary, string_variant: String) -> Term<'a> {
    let variant = match string_to_variant(env, string_variant) {
        Ok(var) => var,
        Err(err) => return err,
    };

    let mut u5_vec = data.as_slice().to_base32();
    u5_vec.insert(0, u5::try_from_u8(1).unwrap());

    match bech32::encode(&hrp, u5_vec, variant) {
        Err(_) => (atoms::error(), atoms::encode_error()).encode(env),
        Ok(encoded) => (atoms::ok(), encoded.to_string()).encode(env),
    }
}

#[rustler::nif]
fn decode<'a>(env: Env<'a>, encoded: String) -> Term<'a> {
    match bech32::decode(&encoded) {
        Ok((hrp, base32_data, variant)) => {
            let slice_data = Vec::<u8>::from_base32(&base32_data).unwrap();

            let mut erl_bin: OwnedBinary = OwnedBinary::new(slice_data.len()).unwrap();
            erl_bin.as_mut_slice().copy_from_slice(&slice_data);

            let string_variant = variant_to_string(variant);

            (atoms::ok(), (hrp, erl_bin.release(env), string_variant)).encode(env)
        }

        Err(_) => (atoms::error(), atoms::decode_error()).encode(env),
    }
}

fn variant_to_string(variant: Variant) -> String {
    match variant {
        Variant::Bech32 => "bech32".to_string(),
        Variant::Bech32m => "bech32m".to_string(),
    }
}

fn string_to_variant<'a>(env: Env<'a>, string_variant: String) -> Result<Variant, Term<'a>> {
    match string_variant.as_str() {
        "bech32" => Ok(Variant::Bech32),
        "bech32m" => Ok(Variant::Bech32m),
        _ => Err((atoms::error(), atoms::invalid_variant()).encode(env)),
    }
}

rustler::init!("Elixir.ExBech32.Impl", [encode, decode]);

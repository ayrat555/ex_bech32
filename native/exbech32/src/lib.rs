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
fn encode_with_version<'a>(
    env: Env<'a>,
    hrp: String,
    version: u8,
    data: Binary,
    string_variant: String,
) -> Term<'a> {
    let mut u5_vec = data.as_slice().to_base32();
    u5_vec.insert(0, u5::try_from_u8(version).unwrap());

    do_encode(env, &hrp, u5_vec, string_variant)
}

#[rustler::nif]
fn encode<'a>(env: Env<'a>, hrp: String, data: Binary, string_variant: String) -> Term<'a> {
    let u5_vec = data.as_slice().to_base32();

    do_encode(env, &hrp, u5_vec, string_variant)
}

#[rustler::nif]
fn decode_with_version<'a>(env: Env<'a>, encoded: String) -> Term<'a> {
    match do_decode(env, encoded) {
        Ok((hrp, base32_data, variant)) => {
            let mut actual_data = Vec::<u8>::from_base32(&base32_data).unwrap();
            let version = actual_data.split_off(1);

            let mut erl_bin: OwnedBinary = OwnedBinary::new(actual_data.len()).unwrap();
            erl_bin.as_mut_slice().copy_from_slice(&actual_data);

            let string_variant = variant_to_string(variant);

            (
                atoms::ok(),
                (hrp, version[0], erl_bin.release(env), string_variant),
            )
                .encode(env)
        }

        Err(error) => return error,
    }
}

#[rustler::nif]
fn decode<'a>(env: Env<'a>, encoded: String) -> Term<'a> {
    match do_decode(env, encoded) {
        Ok((hrp, base32_data, variant)) => {
            let slice_data = Vec::<u8>::from_base32(&base32_data).unwrap();

            let mut erl_bin: OwnedBinary = OwnedBinary::new(slice_data.len()).unwrap();
            erl_bin.as_mut_slice().copy_from_slice(&slice_data);

            let string_variant = variant_to_string(variant);

            (atoms::ok(), (hrp, erl_bin.release(env), string_variant)).encode(env)
        }

        Err(error) => return error,
    }
}

fn do_encode<'a>(env: Env<'a>, hrp: &str, data: Vec<u5>, string_variant: String) -> Term<'a> {
    let variant = match string_to_variant(env, string_variant) {
        Ok(var) => var,
        Err(err) => return err,
    };

    match bech32::encode(hrp, data, variant) {
        Err(_) => (atoms::error(), atoms::encode_error()).encode(env),
        Ok(encoded) => (atoms::ok(), encoded.to_string()).encode(env),
    }
}

fn do_decode<'a>(env: Env<'a>, encoded: String) -> Result<(String, Vec<u5>, Variant), Term<'a>> {
    let decoded = bech32::decode(&encoded);

    if let Err(_) = decoded {
        return Err((atoms::error(), atoms::decode_error()).encode(env));
    }

    Ok(decoded.unwrap())
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

rustler::init!(
    "Elixir.ExBech32.Impl",
    [encode, decode, encode_with_version, decode_with_version]
);

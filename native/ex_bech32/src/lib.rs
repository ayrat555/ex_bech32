use bech32::segwit;
use bech32::Fe32;
use bech32::Hrp;
use rustler::Binary;
use rustler::Encoder;
use rustler::Env;
use rustler::NewBinary;
use rustler::Term;

mod atoms {
    rustler::atoms! {
        ok,
        error,
        encode_error,
        decode_error,
        invalid_variant,
        invalid_hrp,
        invalid_version
    }
}

#[rustler::nif]
fn encode_with_version<'a>(
    env: Env<'a>,
    hrp_string: String,
    version: u8,
    data: Binary,
) -> Term<'a> {
    let hrp = match Hrp::parse(&hrp_string) {
        Ok(hrp) => hrp,
        Err(_) => return (atoms::error(), atoms::invalid_hrp()).encode(env),
    };

    let version = match parse_version(env, version) {
        Ok(version) => version,
        Err(_) => return (atoms::error(), atoms::invalid_version()).encode(env),
    };

    match segwit::encode(hrp, version, data.as_slice()) {
        Err(_) => (atoms::error(), atoms::encode_error()).encode(env),
        Ok(encoded) => (atoms::ok(), encoded.to_string()).encode(env),
    }
}

#[rustler::nif]
fn decode_with_version<'a>(env: Env<'a>, encoded: String) -> Term<'a> {
    match segwit::decode(&encoded) {
        Ok((hrp, version, data)) => {
            let mut erl_bin = NewBinary::new(env, data.len());
            erl_bin.as_mut_slice().copy_from_slice(&data);

            (
                atoms::ok(),
                (hrp.as_str(), version.to_u8(), Binary::from(erl_bin)),
            )
                .encode(env)
        }

        Err(_error) => (atoms::error(), atoms::decode_error()).encode(env),
    }
}

fn parse_version<'a>(env: Env<'a>, version: u8) -> Result<Fe32, Term<'a>> {
    let version = match version {
        0 => segwit::VERSION_0,
        1 => segwit::VERSION_1,
        _ => return Err((atoms::error(), atoms::invalid_version()).encode(env)),
    };

    Ok(version)
}

rustler::init!(
    "Elixir.ExBech32.Impl",
    [encode_with_version, decode_with_version]
);

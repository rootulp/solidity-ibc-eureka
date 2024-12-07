use thiserror::Error;

use ethereum_light_client::types::bls::{BlsPublicKey, BlsSignature};

pub struct TestBlsVerifier;

#[derive(Error, Debug)]
pub enum BlsError {
    #[error("bls error: {0}")]
    Bls(String),
}

pub fn fast_aggregate_verify(
    public_keys: Vec<&BlsPublicKey>,
    msg: alloy_primitives::B256,
    signature: BlsSignature,
) -> Result<(), BlsError> {
    let public_keys = public_keys
        .iter()
        .cloned()
        .map(|pk| milagro_bls::PublicKey::from_bytes(pk.as_ref()))
        .collect::<Result<Vec<milagro_bls::PublicKey>, _>>()
        .map_err(|_| BlsError::Bls("failed to convert to milagro_bls public keys".to_string()))?;

    let public_keys: Vec<&milagro_bls::PublicKey> = public_keys.iter().collect();

    let signature = milagro_bls::Signature::from_bytes(signature.as_slice())
        .map_err(|_| BlsError::Bls("failed to convert to milagro_bls signature".to_string()))?;

    let aggregate_signature = milagro_bls::AggregateSignature::aggregate(&[&signature]);
    let aggregate_pubkey = milagro_bls::AggregatePublicKey::aggregate(&public_keys)
        .map_err(|_| BlsError::Bls("failed to aggregate public keys".to_string()))?;

    let res =
        aggregate_signature.fast_aggregate_verify_pre_aggregated(msg.as_slice(), &aggregate_pubkey);
    if res {
        Ok(())
    } else {
        Err(BlsError::Bls("failed to verify signature".to_string()))
    }
}

pub fn aggreagate(public_keys: Vec<&BlsPublicKey>) -> Result<BlsPublicKey, BlsError> {
    let public_keys = public_keys
        .iter()
        .cloned()
        .map(|pk| milagro_bls::PublicKey::from_bytes(pk.as_ref()))
        .collect::<Result<Vec<milagro_bls::PublicKey>, _>>()
        .map_err(|_| BlsError::Bls("failed to convert to milagro_bls public keys".to_string()))?;

    let public_keys: Vec<&milagro_bls::PublicKey> = public_keys.iter().collect();

    let aggregate_pubkey = milagro_bls::AggregatePublicKey::aggregate(&public_keys)
        .map_err(|_| BlsError::Bls("failed to aggregate public keys".to_string()))?;

    let pubkey = milagro_bls::PublicKey {
        point: aggregate_pubkey.point,
    };

    Ok(BlsPublicKey::from(pubkey.as_bytes()))
}

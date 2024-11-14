// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.28;

// solhint-disable no-inline-assembly

import { Strings } from "@openzeppelin/utils/Strings.sol";
import { IICS20Errors } from "../errors/IICS20Errors.sol";
import { IICS26RouterMsgs } from "../msgs/IICS26RouterMsgs.sol";
import { IICS20TransferMsgs } from "../msgs/IICS20TransferMsgs.sol";
import { IBCERC20 } from "./IBCERC20.sol";

// This library was originally copied, with minor adjustments, from https://github.com/hyperledger-labs/yui-ibc-solidity
// It has since been modified heavily (e.g. replacing JSON with ABI encoding, adding new functions, etc.)
library ICS20Lib {
    /// @notice FungibleTokenPacketData is the payload for a fungible token transfer packet.
    /// @dev PacketData is defined in
    /// [ICS-20](https://github.com/cosmos/ibc/tree/main/spec/app/ics-020-fungible-token-transfer).
    /// @param denom The denomination of the token
    /// @param sender The sender of the token
    /// @param receiver The receiver of the token
    /// @param amount The amount of tokens
    /// @param memo Optional memo
    struct FungibleTokenPacketData {
        string denom;
        string sender;
        string receiver;
        uint256 amount;
        string memo;
    }

    /// @notice ICS20_VERSION is the version string for ICS20 packet data.
    string public constant ICS20_VERSION = "ics20-1";

    /// @notice ICS20_ENCODING is the encoding string for ICS20 packet data.
    string public constant ICS20_ENCODING = "application/x-solidity-abi";

    /// @notice IBC_DENOM_PREFIX is the prefix for IBC denoms.
    string public constant IBC_DENOM_PREFIX = "ibc/";

    /// @notice DEFAULT_PORT_ID is the default port id for ICS20.
    string public constant DEFAULT_PORT_ID = "transfer";

    /// @notice SUCCESSFUL_ACKNOWLEDGEMENT_JSON is the JSON bytes for a successful acknowledgement.
    bytes public constant SUCCESSFUL_ACKNOWLEDGEMENT_JSON = bytes("{\"result\":\"AQ==\"}");
    /// @notice FAILED_ACKNOWLEDGEMENT_JSON is the JSON bytes for a failed acknowledgement.
    bytes public constant FAILED_ACKNOWLEDGEMENT_JSON = bytes("{\"error\":\"failed\"}");
    /// @notice KECCAK256_SUCCESSFUL_ACKNOWLEDGEMENT_JSON is the keccak256 hash of SUCCESSFUL_ACKNOWLEDGEMENT_JSON.
    bytes32 internal constant KECCAK256_SUCCESSFUL_ACKNOWLEDGEMENT_JSON = keccak256(SUCCESSFUL_ACKNOWLEDGEMENT_JSON);

<<<<<<< HEAD
    /// @notice A dummy function to generate the ABI for the parameters.
    /// @param o1 The FungibleTokenPacketData.
    function abiPublicTypes(FungibleTokenPacketData memory o1) public pure 
    // solhint-disable-next-line no-empty-blocks
    {
        // This is a dummy function to generate the ABI for outputs
        // so that it can be used in the SP1 verifier contract.
        // The function is not used in the contract.
    }

    /// @notice Create a MsgSendPacket for an ics20-1 transfer
    /// @notice This function is meant as a helper function to easily construct a correct MsgSendPacket
    /// @return The constructed MsgSendPacket
    function newMsgSendPacketV1(
        address sender,
        IICS20TransferMsgs.SendTransferMsg memory msg_
=======
    /// @notice CHAR_DOUBLE_QUOTE is the ASCII value for double quote.
    uint256 private constant CHAR_DOUBLE_QUOTE = 0x22;
    /// @notice CHAR_SLASH is the ASCII value for slash.
    uint256 private constant CHAR_SLASH = 0x2f;
    /// @notice CHAR_BACKSLASH is the ASCII value for backslash.
    uint256 private constant CHAR_BACKSLASH = 0x5c;
    /// @notice CHAR_F is the ASCII value for 'f'.
    uint256 private constant CHAR_F = 0x66;
    /// @notice CHAR_R is the ASCII value for 'r'.
    uint256 private constant CHAR_R = 0x72;
    /// @notice CHAR_N is the ASCII value for 'n'.
    uint256 private constant CHAR_N = 0x6e;
    /// @notice CHAR_B is the ASCII value for 'b'.
    uint256 private constant CHAR_B = 0x62;
    /// @notice CHAR_T is the ASCII value for 't'.
    uint256 private constant CHAR_T = 0x74;
    /// @notice CHAR_CLOSING_BRACE is the ASCII value for closing brace '}'.
    uint256 private constant CHAR_CLOSING_BRACE = 0x7d;
    /// @notice CHAR_M is the ASCII value for 'm'.
    uint256 private constant CHAR_M = 0x6d;

    /**
     * @notice Encodes a `PacketDataJSON` struct into ABI-encoded bytes.
     * 
     * @dev This function uses `abi.encode` to convert a `PacketDataJSON` struct into its ABI-encoded
     * `bytes` representation. The resulting bytes can be transmitted or stored for decoding later.
     * 
     * @param payload The `PacketDataJSON` struct to encode.
     * @return Encoded `bytes` representation of the input struct.
     * 
     * @dev What this function does:
     * - Converts the `PacketDataJSON` struct into a `bytes` array using ABI encoding.
     * - Ensures the resulting bytes are compatible with `abi.decode` for the same struct.
     * - Preserves the field order and data structure of the input struct during encoding.
     * 
     * @dev What this function does NOT do:
     * - It does not validate the content of the `PacketDataJSON` struct before encoding.
     *   For example:
     *     - Does not check if `amount` is greater than 0.
     *     - Does not verify that `receiver` or `sender` are valid addresses or non-empty strings.
     *     - Does not validate the format or expected content of `denom` or `memo`.
     * - It does not ensure compatibility with external systems unless they adhere to the same ABI encoding rules.
     * 
     * @dev Recommended validation to avoid issues:
     * - Validate the fields of the `PacketDataJSON` struct before calling this function:
     *   - Ensure `amount > 0`.
     *   - Check that `receiver` and `sender` are non-empty and, if required, valid address strings.
     *   - Validate `denom` against expected formats or whitelisted values, if applicable.
     *   - Optionally validate `memo` for length or allowed characters.
     * - Ensure that the consumer of the encoded bytes uses the same ABI decoding standard.
     */
    /// @notice Encodes an ICS20Payload struct into ABI bytes.
    /// @param payload The ICS20Payload struct to encode
    /// @return Encoded bytes
    function encodePayload(PacketDataJSON memory payload) internal pure returns (bytes memory) {
        return abi.encode(payload);
    }

    /**
     * @notice Decodes ABI-encoded bytes into a `PacketDataJSON` struct.
     * 
     * @dev This function uses `abi.decode` to decode a `bytes` payload into a `PacketDataJSON` struct.
     * It assumes that the input data is correctly ABI-encoded and matches the structure of `PacketDataJSON`.
     * 
     * @param data ABI-encoded bytes representing a `PacketDataJSON`.
     * @return Decoded `PacketDataJSON` struct.
     * 
     * @dev What this function does:
     * - Decodes the `bytes` payload into the expected `PacketDataJSON` struct.
     * - Ensures that the payload conforms to the ABI encoding of `PacketDataJSON` (field types and order).
     * - Reverts if the input data is not properly ABI-encoded.
     * 
     * @dev What this function does NOT do:
     * - Validate the logical correctness or semantic meaning of the decoded fields.
     *   For example:
     *     - Does not check if `amount` is greater than 0.
     *     - Does not verify that `receiver` or `sender` are valid addresses or non-empty strings.
     *     - Does not validate the format, length, or expected content of `denom` or `memo`.
     * - Does not validate whether the payload matches a specific JSON schema or key order.
     * 
     * @dev Recommended validation to avoid exploits:
     * - After decoding, validate each field of the struct:
     *   - Ensure `amount > 0`.
     *   - Check that `receiver` and `sender` are non-empty and, if required, valid address strings.
     *   - Validate `denom` against expected formats or whitelisted values, if applicable.
     *   - Optionally validate `memo` for length or allowed characters.
     * - Implement JSON key-order validation if strict ordering is required.
     * - Consider using a try/catch block for decoding, or handle decoding errors explicitly to ensure
     *   the function does not fail silently or revert without providing clear error messages.
     */
    /// @notice Decodes ABI-encoded bytes into an ICS20Payload struct.
    /// @param data ABI-encoded bytes representing an ICS20Payload
    /// @return Decoded ICS20Payload struct
    function decodePayload(bytes memory data) external pure returns (PacketDataJSON memory) {
        return abi.decode(data, (PacketDataJSON));
    }

    /// @notice marshalJSON marshals PacketData into JSON bytes with escaping.
    /// @param escapedDenom Escaped denom
    /// @param amount Amount
    /// @param escapedSender Escaped sender
    /// @param escapedReceiver Escaped receiver
    /// @param escapedMemo Escaped memo
    /// @return Marshalled JSON bytes
    function marshalJSON(
        string memory escapedDenom,
        uint256 amount,
        string memory escapedSender,
        string memory escapedReceiver,
        string memory escapedMemo
>>>>>>> 0d643e0 (fix transfer tests)
    )
        internal
        view
        returns (IICS26RouterMsgs.MsgSendPacket memory)
    {
        require(msg_.amount > 0, IICS20Errors.ICS20InvalidAmount(msg_.amount));

        string memory fullDenomPath;
        try IBCERC20(mustHexStringToAddress(msg_.denom)).fullDenomPath() returns (string memory ibcERC20FullDenomPath) {
            // if the address is one of our IBCERC20 contracts, we get the correct denom for the packet there
            fullDenomPath = ibcERC20FullDenomPath;
        } catch {
            // otherwise this is just an ERC20 address, so we use it as the denom
            fullDenomPath = msg_.denom;
        }

        // We are encoding the payload in ABI format
        bytes memory packetData = abi.encode(
            ICS20Lib.FungibleTokenPacketData({
                denom: fullDenomPath,
                sender: Strings.toHexString(sender),
                receiver: msg_.receiver,
                amount: msg_.amount,
                memo: msg_.memo
            })
        );

        IICS26RouterMsgs.Payload[] memory payloads = new IICS26RouterMsgs.Payload[](1);
        payloads[0] = IICS26RouterMsgs.Payload({
            sourcePort: ICS20Lib.DEFAULT_PORT_ID,
            destPort: msg_.destPort,
            version: ICS20Lib.ICS20_VERSION,
            encoding: ICS20Lib.ICS20_ENCODING,
            value: packetData
        });
        return IICS26RouterMsgs.MsgSendPacket({
            sourceChannel: msg_.sourceChannel,
            timeoutTimestamp: msg_.timeoutTimestamp,
            payloads: payloads
        });
    }

    /// @notice hexStringToAddress converts a hex string to an address.
    /// @param addrHexString hex address string
    /// @return address value
    /// @return true if the conversion was successful
    function hexStringToAddress(string memory addrHexString) internal pure returns (address, bool) {
        bytes memory addrBytes = bytes(addrHexString);
        if (addrBytes.length != 42) {
            return (address(0), false);
        } else if (addrBytes[0] != "0" || addrBytes[1] != "x") {
            return (address(0), false);
        }
        uint256 addr = 0;
        unchecked {
            for (uint256 i = 2; i < 42; i++) {
                uint256 c = uint256(uint8(addrBytes[i]));
                if (c >= 48 && c <= 57) {
                    addr = addr * 16 + (c - 48);
                } else if (c >= 97 && c <= 102) {
                    addr = addr * 16 + (c - 87);
                } else if (c >= 65 && c <= 70) {
                    addr = addr * 16 + (c - 55);
                } else {
                    return (address(0), false);
                }
            }
        }
        return (address(uint160(addr)), true);
    }

    /// @notice mustHexStringToAddress converts a hex string to an address and reverts on failure.
    /// @param addrHexString hex address string
    /// @return address the converted address
    function mustHexStringToAddress(string memory addrHexString) internal pure returns (address) {
        (address addr, bool success) = hexStringToAddress(addrHexString);
        require(success, IICS20Errors.ICS20InvalidAddress(addrHexString));
        return addr;
    }

    /// @notice slice returns a slice of the original bytes from `start` to `start + length`.
    /// @dev This is a copy from https://github.com/GNSPS/solidity-bytes-utils/blob/v0.8.0/contracts/BytesLib.sol
    /// @param _bytes bytes
    /// @param _start start index
    /// @param _length length
    /// @return sliced bytes
    function slice(bytes memory _bytes, uint256 _start, uint256 _length) internal pure returns (bytes memory) {
        if (_length + 31 < _length) {
            revert IICS20Errors.ICS20BytesSliceOverflow(_length);
        } else if (_start + _length > _bytes.length) {
            revert IICS20Errors.ICS20BytesSliceOutOfBounds(_bytes.length, _start, _start + _length);
        }

        bytes memory tempBytes;

        assembly {
            switch iszero(_length)
            case 0 {
                // Get a location of some free memory and store it in tempBytes as
                // Solidity does for memory variables.
                tempBytes := mload(0x40)

                // The first word of the slice result is potentially a partial
                // word read from the original array. To read it, we calculate
                // the length of that partial word and start copying that many
                // bytes into the array. The first word we copy will start with
                // data we don't care about, but the last `lengthmod` bytes will
                // land at the beginning of the contents of the new array. When
                // we're done copying, we overwrite the full first word with
                // the actual length of the slice.
                let lengthmod := and(_length, 31)

                // The multiplication in the next line is necessary
                // because when slicing multiples of 32 bytes (lengthmod == 0)
                // the following copy loop was copying the origin's length
                // and then ending prematurely not copying everything it should.
                let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
                let end := add(mc, _length)

                for {
                    // The multiplication in the next line has the same exact purpose
                    // as the one above.
                    let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
                } lt(mc, end) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } { mstore(mc, mload(cc)) }

                mstore(tempBytes, _length)

                //update free-memory pointer
                //allocating the array padded to 32 bytes like the compiler does now
                mstore(0x40, and(add(mc, 31), not(31)))
            }
            //if we want a zero-length slice let's just return a zero-length array
            default {
                tempBytes := mload(0x40)
                //zero out the 32 bytes slice we are about to return
                //we need to do it because Solidity does not garbage collect
                mstore(tempBytes, 0)

                mstore(0x40, add(tempBytes, 0x20))
            }
        }

        return tempBytes;
    }

    /// @notice equal returns true if two byte arrays are equal.
    /// @param a bytes
    /// @param b bytes
    /// @return true if the byte arrays are equal
    function equal(bytes memory a, bytes memory b) internal pure returns (bool) {
        return keccak256(a) == keccak256(b);
    }

    /// @notice hasPrefix checks a denom for a prefix
    /// @param denomBz the denom to check
    /// @param prefix the prefix to check with
    /// @return true if `denomBz` has the prefix `prefix`
    function hasPrefix(bytes memory denomBz, bytes memory prefix) internal pure returns (bool) {
        if (denomBz.length < prefix.length) {
            return false;
        }
        return equal(slice(denomBz, 0, prefix.length), prefix);
    }

    /// @notice errorAck returns an error acknowledgement.
    /// @param reason Error reason
    /// @return Error acknowledgement
    function errorAck(bytes memory reason) internal pure returns (bytes memory) {
        return abi.encodePacked("{\"error\":\"", reason, "\"}");
    }

    /// @notice getDenomPrefix returns an ibc path prefix
    /// @param port Port
    /// @param channel Channel
    /// @return Denom prefix
    function getDenomPrefix(string calldata port, string calldata channel) internal pure returns (bytes memory) {
        return abi.encodePacked(port, "/", channel, "/");
    }

    /// @notice toIBCDenom converts a full denom path to an ibc/hash(trace+base_denom) denom
    /// @notice there is no check if the denom passed in is a base denom (if it has no trace), so it is assumed
    /// @notice that the denom passed in is a full denom path with trace and base denom
    /// @param fullDenomPath full denom path with trace and base denom
    /// @return IBC denom in the format ibc/hash(trace+base_denom)
    function toIBCDenom(string memory fullDenomPath) public pure returns (string memory) {
        string memory hash = toHexHash(fullDenomPath);
        return string(abi.encodePacked(IBC_DENOM_PREFIX, hash));
    }

    /// @notice toHexHash converts a string to an all uppercase hex hash (without the 0x prefix)
    /// @param str string to convert
    /// @return uppercase hex hash without 0x prefix
    function toHexHash(string memory str) public pure returns (string memory) {
        bytes32 hash = sha256(bytes(str));
        bytes memory hexBz = bytes(Strings.toHexString(uint256(hash)));

        // next we remove the `0x` prefix and uppercase the hash string
        bytes memory finalHex = new bytes(hexBz.length - 2); // we skip the 0x prefix

        for (uint256 i = 2; i < hexBz.length; i++) {
            // if lowercase a-z, convert to uppercase
            if (hexBz[i] >= 0x61 && hexBz[i] <= 0x7A) {
                finalHex[i - 2] = bytes1(uint8(hexBz[i]) - 32);
            } else {
                finalHex[i - 2] = hexBz[i];
            }
        }

        return string(finalHex);
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// solhint-disable custom-errors,max-line-length

import { Test } from "forge-std/Test.sol";
import { ICS24Host } from "../src/utils/ICS24Host.sol";
import { IICS26RouterMsgs } from "../src/msgs/IICS26RouterMsgs.sol";
import { ICS20Lib } from "../src/utils/ICS20Lib.sol";
import { Strings } from "@openzeppelin/utils/Strings.sol";

contract ICS24HostTest is Test {
    bytes[] public ibcPrefix = [bytes("ibc"), bytes("")];
    bytes[] public otherPrefix = [bytes("ibc"), bytes("test/")];

    struct IBCPrefixedPathTestCase {
        bytes[] prefix;
        bytes path;
        bytes[2] expected;
    }

    function test_prefixedPath() public view {
        // Test cases against the ibc-go implementations output
        IBCPrefixedPathTestCase[2] memory testCases = [
            IBCPrefixedPathTestCase(
                ibcPrefix,
                abi.encodePacked("clients/07-tendermint-0/clientState"),
                [bytes("ibc"), bytes("clients/07-tendermint-0/clientState")]
            ),
            IBCPrefixedPathTestCase(
                otherPrefix,
                abi.encodePacked("clients/07-tendermint-0/clientState"),
                [bytes("ibc"), bytes("test/clients/07-tendermint-0/clientState")]
            )
        ];

        for (uint256 i = 0; i < testCases.length; i++) {
            IBCPrefixedPathTestCase memory testCase = testCases[i];
            bytes[] memory actual = ICS24Host.prefixedPath(testCase.prefix, testCase.path);
            assertEq(actual.length, 2);
            assertEq(actual[0], testCase.expected[0]);
            assertEq(actual[1], testCase.expected[1]);
        }
    }

    function test_packetCommitment() public pure {
        // Test against the ibc-go implementations output
        //bytes memory transferPayload = ICS20Lib.marshalJSON("uatom", 1_000_000, "sender", "receiver", "memo");

        ICS20Lib.FungibleTokenPacketData memory pd;
        pd.denom = "uatom";
        pd.amount = 1_000_000;
        pd.sender = "sender";
        pd.receiver = "receiver";
        pd.memo = "memo";

        bytes memory transferPayload = ICS20Lib.encodePayload(pd);

        IICS26RouterMsgs.Payload[] memory payloads = new IICS26RouterMsgs.Payload[](1);
        payloads[0] = IICS26RouterMsgs.Payload({
            sourcePort: "transfer",
            destPort: "transfer",
            version: ICS20Lib.ICS20_VERSION,
            encoding: ICS20Lib.ICS20_ENCODING,
            value: transferPayload
        });

        IICS26RouterMsgs.Packet memory packet = IICS26RouterMsgs.Packet({
            sequence: 1,
            sourceChannel: "channel-0",
            destChannel: "channel-1",
            timeoutTimestamp: 100,
            payloads: payloads
        });

        bytes32 commitmentBytes = ICS24Host.packetCommitmentBytes32(packet);
        string memory actual = Strings.toHexString(uint256(commitmentBytes));
        string memory expected = "0xb8c6a88d36151c8ab21cb1c1c342a87c18d4f7110f0eee7e076ce56328f6eea8";
        assertEq(actual, expected);
    }

    function test_packetAcknowledgementCommitment() public pure {
        // Test against the ibc-go implementations output
        bytes memory ack = abi.encodePacked("some bytes");
        bytes[] memory acks = new bytes[](1);
        acks[0] = ack;
        bytes32 ackHash = ICS24Host.packetAcknowledgementCommitmentBytes32(acks);
        string memory actualAckHash = Strings.toHexString(uint256(ackHash));
        string memory expectedAckHash = "0xf03b4667413e56aaf086663267913e525c442b56fa1af4fa3f3dab9f37044c5b";
        assertEq(actualAckHash, expectedAckHash);
    }

    function test_packetKeys() public pure {
        // Test against the ibc-go implementations output
        bytes memory packetCommitmentKey = ICS24Host.packetCommitmentPathCalldata("channel-0", 1);
        string memory actualCommitmentKey = bytesToHex(packetCommitmentKey);
        string memory expectedCommitmentKey = "6368616e6e656c2d30010000000000000001";
        assertEq(actualCommitmentKey, expectedCommitmentKey);

        bytes memory packetReceiptCommitmentKey = ICS24Host.packetReceiptCommitmentPathCalldata("channel-1", 2);
        string memory actualReceiptCommitmentKey = bytesToHex(packetReceiptCommitmentKey);
        string memory expectedReceiptCommitmentKey = "6368616e6e656c2d31020000000000000002";
        assertEq(actualReceiptCommitmentKey, expectedReceiptCommitmentKey);

        bytes memory packetAcknowledgementCommitmentKey =
            ICS24Host.packetAcknowledgementCommitmentPathCalldata("channel-2", 3);
        string memory actualAcknowledgementCommitmentKey = bytesToHex(packetAcknowledgementCommitmentKey);
        string memory expectedAcknowledgementCommitmentKey = "6368616e6e656c2d32030000000000000003";
        assertEq(actualAcknowledgementCommitmentKey, expectedAcknowledgementCommitmentKey);
    }

    function bytesToHex(bytes memory data) public pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(2 * data.length);
        for (uint256 i = 0; i < data.length; i++) {
            str[2 * i] = alphabet[uint8(data[i] >> 4)];
            str[2 * i + 1] = alphabet[uint8(data[i] & 0x0f)];
        }
        return string(str);
    }
}

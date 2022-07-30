pragma solidity ^0.8.13;

import "./Rocket.sol";

contract RocketFactory {
    function deploy(
        address approvalTarget,
        address token,
        address receiver,
        uint256 amount
    )
        public
        payable
        returns (address)
    {
        // This syntax is a newer way to invoke create2 without assembly, you just need to pass salt
        // https://docs.soliditylang.org/en/latest/control-structures.html#salted-contract-creations-create2
        bytes32 uniqueSalt =
            keccak256(abi.encode(approvalTarget, token, receiver, amount));
        return address(new Rocket{salt:  uniqueSalt}(uniqueSalt));
    }

    function getAddressFor(
        address approvalTarget,
        address token,
        address receiver,
        uint256 amount
    )
        external
        view
        returns (address)
    {
        bytes32 salt =
            keccak256(abi.encode(approvalTarget, token, receiver, amount));
        address predictedAddress = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            address(this),
                            salt,
                            keccak256(abi.encodePacked(type(Rocket).creationCode, abi.encode(salt)))
                        )
                    )
                )
            )
        );

        return predictedAddress;
    }
}

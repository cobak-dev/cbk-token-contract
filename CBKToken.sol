// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Cobak Token
/// @notice Standard ERC20 token with no admin functions, no upgrade mechanism.
/// @dev Initial total supply is minted to the Safe (multisig) distribution wallet,
///      which is used to distribute tokens to exchanges, swap contracts and users.
contract CBKToken is ERC20 {
    /// @notice The Safe (multisig) wallet that initially holds all tokens for distribution
    address public immutable distributionSafeWallet;

    /// @param totalSupply Total supply of the token
    /// @param _distributionSafeWallet Safe wallet address that will initially receive all tokens
    constructor(
        uint256 totalSupply,
        address _distributionSafeWallet
    ) ERC20("Cobak Token", "CBK") {
        require(
            _distributionSafeWallet != address(0),
            "Invalid distribution wallet address"
        );
        distributionSafeWallet = _distributionSafeWallet;

        // Mint the entire supply to the Safe distribution wallet
        _mint(distributionSafeWallet, totalSupply);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/// @title CBK Token Swap (Ethereum)
/// @notice Swaps old CBK for new CBK at a fixed 1:1 ratio.
///         Swapped-in old tokens are held by this contract forever — there is
///         intentionally no withdrawal path (for old tokens or anything else
///         sent here by mistake), so locked tokens are effectively burned.
/// @dev New tokens are paid from the vault (Safe multisig) via allowance;
///      the vault approving zero acts as the operational kill switch.
contract TokenSwap is ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public immutable oldToken;
    IERC20 public immutable newToken;
    /// @notice Vault (Safe multisig) funding new-token payouts
    address public immutable vault;

    event Swapped(address indexed user, uint256 oldAmount, uint256 newAmount);

    constructor(address _oldToken, address _newToken, address _vault) {
        require(
            _oldToken != address(0) && _newToken != address(0),
            "Invalid token address"
        );
        require(_oldToken != _newToken, "Tokens must differ");
        require(_vault != address(0), "Invalid vault");
        oldToken = IERC20(_oldToken);
        newToken = IERC20(_newToken);
        vault = _vault;
    }

    /// @notice Swap `oldAmount` old CBK for the same amount of new CBK.
    /// @dev Caller must approve this contract for `oldAmount` old CBK beforehand.
    /// @param oldAmount Amount of old CBK to swap
    function swap(uint256 oldAmount) external nonReentrant {
        require(oldAmount > 0, "Amount must be > 0");

        // 1) Lock old tokens in this contract permanently (no withdrawal path)
        oldToken.safeTransferFrom(msg.sender, address(this), oldAmount);

        // 2) Pay out new tokens from the vault within its allowance
        newToken.safeTransferFrom(vault, msg.sender, oldAmount);

        emit Swapped(msg.sender, oldAmount, oldAmount);
    }
}

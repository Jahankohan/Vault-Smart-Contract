// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Interface for Wrapped Ether (WETH)
/// @notice This interface defines the standard functions for interacting with Wrapped Ether (WETH), allowing for the deposit and withdrawal of Ether in a way that is compatible with ERC-20 token standards.
interface IWETH {
    /// @notice Deposits Ether and converts it into WETH tokens.
    /// @dev This function should be called with the payable modifier to allow it to accept Ether.
    function deposit() external payable;

    /// @notice Withdraws Ether by burning the caller's WETH tokens.
    /// @param amount The amount of WETH to withdraw (un-wrap), which will be burned.
    function withdraw(uint amount) external;

    /// @notice Returns the balance of WETH tokens held by a specific account.
    /// @param account The address of the account whose balance will be checked.
    /// @return The balance of WETH tokens held by the account.
    function balanceOf(address account) external view returns (uint);
}

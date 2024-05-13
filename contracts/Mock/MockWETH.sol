// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Mock WETH Contract
/// @dev This contract is used for simulating Wrapped Ether (WETH) functionalities in a development environment.
contract MockWETH {
    /// @notice Tracks WETH balances of addresses.
    mapping(address => uint) public balanceOf;

    /// @notice Logs when Ether is deposited and wrapped into WETH.
    /// @param dst The destination address receiving WETH
    /// @param wad The amount of WETH received
    event Deposit(address indexed dst, uint wad);

    /// @notice Logs when WETH is unwrapped and withdrawn as Ether.
    /// @param src The source address withdrawing Ether
    /// @param wad The amount of Ether withdrawn
    event Withdrawal(address indexed src, uint wad);

    /// @notice Allows users to deposit Ether and wrap it into WETH.
    /// @dev Emits a Deposit event upon success.
    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    /// @notice Allows users to withdraw Ether by unwrapping WETH.
    /// @dev Requires that the caller has sufficient WETH balance.
    /// @param wad The amount of WETH to unwrap and withdraw as Ether.
    /// @return sent Indicates whether the Ether transfer was successful.
    function withdraw(uint wad) public returns (bool sent) {
        require(balanceOf[msg.sender] >= wad, "Insufficient balance");
        balanceOf[msg.sender] -= wad;
        (sent, ) = payable(msg.sender).call{value: wad}("");
        require(sent, "Failed to send Ether");
        emit Withdrawal(msg.sender, wad);
        return sent;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./IWETH.sol";

/// @title A vault for managing deposits, withdrawals, and wrapping of ETH and ERC20 tokens, including WETH.
/// @dev This contract implements reentrancy checks using OpenZeppelin's ReentrancyGuard.
contract Vault is ReentrancyGuard {
    using SafeERC20 for IERC20;

    /// @notice Address of the WETH contract.
    IWETH public immutable weth;

    /// @notice Mapping to track ETH balances of users.
    mapping(address => uint256) private _balancesETH;

    /// @notice Mapping to track ERC20 token balances of users.
    mapping(address => mapping(address => uint256)) private _balancesERC20;

    /// @dev Events for depositing and withdrawing assets.
    event DepositedETH(address indexed user, uint256 amount);
    event WithdrawnETH(address indexed user, uint256 amount);
    event DepositedERC20(address indexed user, address indexed token, uint256 amount);
    event WithdrawnERC20(address indexed user, address indexed token, uint256 amount);
    event WrappedETH(address indexed user, uint256 amount);
    event UnwrappedWETH(address indexed user, uint256 amount);

    /// @param _weth The address of the WETH contract to be used.
    constructor(address _weth) {
        weth = IWETH(_weth);
    }

    /// @notice Deposits ETH into the vault.
    function depositETH() public payable {
        _balancesETH[msg.sender] += msg.value;
        emit DepositedETH(msg.sender, msg.value);
    }

    /// @notice Withdraws ETH from the vault.
    /// @param amount The amount of ETH to withdraw.
    function withdrawETH(uint256 amount) public nonReentrant {
        require(_balancesETH[msg.sender] >= amount, "Insufficient balance");
        _balancesETH[msg.sender] -= amount;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send ETH");
        emit WithdrawnETH(msg.sender, amount);
    }

    /// @notice Deposits an ERC20 token into the vault.
    /// @param token The ERC20 token address.
    /// @param amount The amount of tokens to deposit.
    function depositERC20(address token, uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        _balancesERC20[msg.sender][token] += amount;
        emit DepositedERC20(msg.sender, token, amount);
    }

    /// @notice Withdraws an ERC20 token from the vault.
    /// @param token The ERC20 token address.
    /// @param amount The amount of tokens to withdraw.
    function withdrawERC20(address token, uint256 amount) public nonReentrant {
        require(_balancesERC20[msg.sender][token] >= amount, "Insufficient balance");
        _balancesERC20[msg.sender][token] -= amount;
        IERC20(token).safeTransfer(msg.sender, amount);
        emit WithdrawnERC20(msg.sender, token, amount);
    }

    /// @notice Wraps ETH into WETH.
    /// @param amount The amount of ETH to wrap into WETH.
    function wrapETH(uint256 amount) public {
        require(_balancesETH[msg.sender] >= amount, "Insufficient ETH balance");
        _balancesETH[msg.sender] -= amount;
        weth.deposit{value: amount}();
        _balancesERC20[msg.sender][address(weth)] += amount;
        emit WrappedETH(msg.sender, amount);
    }

    /// @notice Unwraps WETH into ETH.
    /// @param amount The amount of WETH to unwrap.
    function unwrapWETH(uint amount) public nonReentrant {
        require(_balancesERC20[msg.sender][address(weth)] >= amount, "Insufficient WETH balance");
        _balancesERC20[msg.sender][address(weth)] -= amount;
        weth.withdraw(amount);
        _balancesETH[msg.sender] += amount;
        emit UnwrappedWETH(msg.sender, amount);
    }

    /// @notice Withdraws WETH as ERC20 tokens.
    /// @param amount The amount of WETH to withdraw.
    function withdrawWETH(uint256 amount) public nonReentrant {
        require(_balancesERC20[msg.sender][address(weth)] >= amount, "Insufficient WETH balance");
        _balancesERC20[msg.sender][address(weth)] -= amount;
        IERC20(address(weth)).safeTransfer(msg.sender, amount);
        emit WithdrawnERC20(msg.sender, address(weth), amount);
    }

    /// @notice Gets the ERC20 token balance of the caller.
    /// @param token The ERC20 token address.
    /// @return The balance of the token.
    function getERC20Balance(address token) public view returns (uint256) {
        return _balancesERC20[msg.sender][token];
    }

    /// @notice Gets the ERC20 token balance of a user.
    /// @param user The user address.
    /// @param token The ERC20 token address.
    /// @return The balance of the token.
    // function getERC20Balance(address user, address token) public view returns (uint256) {
    //     return _balancesERC20[user][token];
    // }

    /// @notice Gets the ETH balance of the caller.
    /// @return The balance of ETH.
    function getETHBalance() public view returns (uint256) {
        return _balancesETH[msg.sender];
    }

    /// @notice Gets the ETH balance of a user.
    /// @param user The user address.
    /// @return The balance of ETH.
    function getETHDimensions(address user) public view returns (uint256) {
        return _balancesETH[user];
    }

    receive() external payable {}

    fallback() external payable {}
}

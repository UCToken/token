// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20FlashMint.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/*
               _  _       ___        _        
 /\ /\  _ __  (_)| |_    / __\ ___  (_) _ __  
/ / \ \|  _ \ | || __|  / /   / _ \ | ||  _ \ 
\ \_/ /| | | || || |_  / /___| (_) || || | | |
 \___/ |_| |_||_| \__| \____/ \___/ |_||_| |_|
                                              
*/
contract UCToken is ERC20Capped, ERC20Burnable, Pausable, Ownable, ERC20FlashMint {
	uint256 public MAX_SUPPLY = 10**7;
	
	/**
	* @dev Sets the values for {owner} and {teamWallet}.
	*/
    constructor(address wallet) 
		ERC20("Unit Coin", "UC") 
		ERC20Capped(MAX_SUPPLY)
		payable
	{
		require(wallet != address(0), 'cannot be zero address');
		
        _mint(msg.sender, (MAX_SUPPLY * 6/10) * 10 ** decimals());
		_mint(wallet, (MAX_SUPPLY * 1/10) * 10 ** decimals());
    }
	
    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
	function decimals() public view virtual override returns (uint8) {
        return 0;
    }

	/**
	* @dev Triggers stopped state.
	*
	* Requirements:
	*
	* - The contract must not be paused.
	*/
    function pause() public onlyOwner {
        _pause();
    }

	/**
	* @dev Returns to normal state.
	*
	* Requirements:
	*
	* - The contract must be paused.
	*/
    function unpause() public onlyOwner {
        _unpause();
    }
	
	/** 
	* @dev Creates `amount` tokens and assigns them to `to`, increasing
	* the total supply.
	*
	* Emits a {Transfer} event with `from` set to the zero address.
	*
	* Requirements:
	*
	* - `to` cannot be the zero address.
	*/
	function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
	
	/** 
	* @dev Set flash mint fee.
	*/
	function setFlashFee(uint256 fee) public onlyOwner {
        _flashFee = fee;
    }

	/**
	* @dev Returns the fee applied when doing flash loans. This function calls the {flashFee} function which returns the fee applied when doing flash loans.
	*/
	uint256 private _flashFee = 10;
    function flashFee(address token, uint256 amount) 
		public 
		view 
		virtual 
		override 
		returns (uint256)
	{
        // silence warning about unused variable without the addition of bytecode.
        token;
        amount;
        return _flashFee;
    }

    /**
     * @dev Returns the receiver address of the flash fee. By default this
     * implementation returns the address(0) which means the fee amount will be burnt.
     * This function can be overloaded to change the fee receiver.
     * @return The address for which the flash fee will be sent to.
     */
    function _flashFeeReceiver() 
		internal 
		view 
		override 
		returns (address) 
	{
        return owner();
    }
	
	/**
     * @dev See {ERC20-_mint}.
     */
    function _mint(address account, uint256 amount) 
		internal 
		virtual 
		override(ERC20, ERC20Capped)
	{
        require(ERC20.totalSupply() + amount <= cap(), "UnitCoin: cap exceeded");
        super._mint(account, amount);
    }
	
	receive() external payable {}
	fallback() external payable {}
}
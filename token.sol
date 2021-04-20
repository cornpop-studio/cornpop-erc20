// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol";

/**
 * @dev Implementation of the {ERC20} contract.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 */
contract CornPop is ERC20 {

    // Variable to store contract owner for modifier
    address owner;

    /*
     * @dev Provides information about the token details, including the
     * name and symbol in the constructor
     *
     * The name and symbol are hard coded and cannot be changed in the future
     */
    constructor() public ERC20("CornPop", "CPOP") {
        // Sender is saved as contract owner
        owner = msg.sender;

        /**
        * @dev Function cannot be called after contract creation,
        * override mint and make it public if you want to be able
        * to create more tokens
        *
        * Mint capped at 100M tokens
        */
        _mint(msg.sender, 100000000 * (10 ** uint256(decimals())));
    }

    /**
     * Modifier to lock contract functions to the owner
     *
      * Requirements:
     *
     * - `sender` must be equal to the owner saved in the constructor
    */
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }

    /**
     * Funds the Initial coin offering specified address
     * with 50,000,000 tokens
     *
     * Requirements:
     *
     * - `sender` must be the owner of the contract.
     * - `_icoAddress` cannot be the zero address.
     */
    function fundICO(address _icoAddress) public onlyOwner {
        transfer(_icoAddress, 50000000);
    }
}
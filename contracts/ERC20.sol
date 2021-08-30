// SPDX-License-Identifier: ISC
pragma solidity 0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

contract ERC20 is ERC20PausableUpgradeable, OwnableUpgradeable {
	using AddressUpgradeable for address;
	using SafeMathUpgradeable for uint256;
	using SafeERC20Upgradeable for IERC20Upgradeable;
	// Constant Max Total Supply of Token Example
 	uint256 private constant _maxTotalSupply = 600_000_000 * (uint256(10) ** uint256(18));

	// paused by blocks
    uint256 public pausedBeforeBlockNumber;
    bool public pausedBeforeBlockNumberDisabled;

    event PausedByBlock(uint256 indexed blocks, uint256 timestamp, uint256 total);
	function initialize() initializer() public {
		__Ownable_init();
		__ERC20_init_unchained('ERC20 paused by blocks', 'ERC20');
		__Pausable_init_unchained();

		// Mint Total Supply
		mint(getMaxTotalSupply());
	}

	/**
     * @dev This Method permit getting Maximun total Supply .
     * See {ERC20-_burn}.
     */
	function getMaxTotalSupply() public pure returns (uint256) {
		return _maxTotalSupply;
	}

	/**
     * @dev Implementation / Instance of paused methods() in the ERC20.
     * @param status Setting the status boolean (True for paused, or False for unpaused)
     * See {ERC20Pausable}.
     */
    function pause(bool status) public onlyOwner() {
        if (status) {
            _pause();
        } else {
            _unpause();
        }
    }

		/**
     * @dev Override the Hook of Open Zeppelin for checking before execute the method transfer/transferFrom/mint/burn.
	 * @param sender Addres of Sender of the token
	 * @param recipient Address of Receptor of the token
     * @param amount Amount token to transfer/transferFrom/mint/burn
     * See {ERC20 Upgradeable}.
     */
	function _beforeTokenTransfer(address sender, address recipient, uint256 amount) internal virtual override {
		// Permit the Owner execute token transfer/mint/burn while paused contract
		if (_msgSender() != owner()) {
			require(!paused(), "ERC20: token transfer/mint/burn while paused");
			require(!isPausedDisabled(), "ERC20: token transfer/mint/burn while paused by block number");
		}
        super._beforeTokenTransfer(sender, recipient, amount);
    }

	/**
     * @dev Creates `amount` new tokens for `to`.
	 * @param _amount Amount Token to mint
     *
     * See {ERC20-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the `OWNER`.
		 * - After upgrade the SmartContract and Eliminate this method
     */
    function mint( uint256 _amount) public onlyOwner() {
		require(getMaxTotalSupply() >= totalSupply().add(_amount), "ERC20: Can't Mint, it exceeds the maximum supply ");
        _mint(owner(), _amount);
    }

	function isPausedDisabled() public view returns (bool) {
		if (_msgSender() == owner()) {
            // owner always can transfer
            return false;
        }
		return (!pausedBeforeBlockNumberDisabled && (block.number < pausedBeforeBlockNumber));
	}

	/**
     * @dev Paused by Block - Block any transfer and burn any tokens
	 * @dev Setting the number of blocks that disable the Transfer methods
	 * @param blocksDuration number of block that transfer are disabled
     */
	function pausedByBlock(uint256 blocksDuration) public onlyOwner {
        require(!pausedBeforeBlockNumberDisabled, "Paused by Block is disabled");
        pausedBeforeBlockNumber = block.number + blocksDuration;
		emit PausedByBlock(blocksDuration, block.number, pausedBeforeBlockNumber);
    }

    function disablePausedByBlockNumber() public onlyOwner {
        pausedBeforeBlockNumber = 0;
        pausedBeforeBlockNumberDisabled = true;
    }


}


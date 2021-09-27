//SPDX-License-Identifier: ISC
pragma solidity 0.8.4;
pragma experimental ABIEncoderV2;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "hardhat/console.sol";

/**
 * @title Test Oracle Chainlink
 * @author Alfredo Lopez 9.2021
 */

contract Rifa is VRFConsumerBase {
	bytes32 internal keyHash;
    uint256 internal fee;

	bytes32 public requestId_;
    uint256 public randomResult;

	event RequestId (bytes32 requestId);
	event RandomResult (bytes32 requestId, uint256 randomResult);

	constructor(address _vfrCoordinator, address _linkToken, bytes32 _keyHash, uint256 _fee)
	VRFConsumerBase(_vfrCoordinator, _linkToken)
	{
		keyHash = _keyHash;
		fee = _fee;
		randomResult = 0;
	}

	/**
     * @dev Requests randomness
     */
    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
		randomResult = 0;
		requestId_  = requestRandomness(keyHash, fee);
		emit RequestId(requestId_);
        return requestId_;
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = (randomness % 1000) + 1;
		emit RandomResult(requestId_, randomResult);
    }

}

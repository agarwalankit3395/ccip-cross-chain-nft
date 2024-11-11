// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {MyNFT} from "./MyNFT.sol";

contract DestinationMinter is CCIPReceiver {
    MyNFT nft;
    
    address _feeTokenAddress;
    address immutable i_router;
    address sourceAddress;
    uint64 immutable destinationChainSelector;

    event MintCallSuccessfull();

    constructor(address router, address nftAddress, address _sourceAddress, address feeTokenAddress, uint64 _destinationChainSelector) CCIPReceiver(router) {
        nft = MyNFT(nftAddress);
        sourceAddress = _sourceAddress;
        _feeTokenAddress = feeTokenAddress;
        destinationChainSelector = _destinationChainSelector;
    }

    function _ccipReceive(Client.Any2EVMMessage memory message) internal override {
        (bool success, ) = address(nft).call(message.data);
        require(success);

        Client.EVM2AnyMessage memory message2 = Client.EVM2AnyMessage({
            receiver: abi.encode(sourceAddress),
            data: abi.encodeWithSignature("mintResponse(string calldata _text)", "Token Minted Sucessfull"),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: "",
            // Set the feeToken to a feeTokenAddress, indicating specific asset will be used for fees
            feeToken: _feeTokenAddress
        });

        bytes32 messageId;

        messageId = IRouterClient(i_router).ccipSend(
            destinationChainSelector,
            message2
        );

        emit MintCallSuccessfull();
    }
}

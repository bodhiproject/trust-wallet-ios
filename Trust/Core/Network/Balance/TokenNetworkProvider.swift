// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore
import PromiseKit
import BigInt
import APIKit
import JSONRPCKit

final class TokenNetworkProvider: BalanceNetworkProvider {

    let server: RPCServer
    let address: EthereumAddress
    let contract: EthereumAddress
    let addressUpdate: EthereumAddress //也是合约地址

    init(
        server: RPCServer,
        address: EthereumAddress,
        contract: EthereumAddress,
        addressUpdate: EthereumAddress
    ) {
        self.server = server
        self.address = address
        self.contract = contract
        self.addressUpdate = addressUpdate
        print("TokenNet::init():\(server),address=\(address), addressUpdate=\(addressUpdate), contract=\(contract)")
    }

    func balance() -> Promise<BigInt> {
        return Promise { seal in
            let encoded = ERC20Encoder.encodeBalanceOf(address: address)
            print("TokenNet::balance():encodeBalanceOf=\(encoded)")
            let request = EtherServiceRequest(
                for: server,
                batch: BatchFactory().create(CallRequest(to: contract.description, data: encoded.hexEncoded))
            )
            print("TokenNet::balance():request=\(request),contract.desc=\(contract.description)")
            Session.send(request) { result in
                switch result {
                case .success(let balance):
                    guard let value = BigInt(balance.drop0x, radix: 16) else {
                        return seal.reject(CookiesStoreError.empty)
                    }
                    seal.fulfill(value)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    func balance2() -> Promise<BigInt> {
        return Promise { seal in
            let encoded = ERC20Encoder.encodeBalanceOf(address: address)
            print("TokenNet::balance():encodeBalanceOf=\(encoded)")
            let request = EtherServiceRequest(
                for: server,
                batch: BatchFactory().create(CallRequest(to: contract.description, data: encoded.hexEncoded))
            )
            print("TokenNet::balance():request=\(request),contract.desc=\(contract.description)")
            Session.send(request) { result in
                switch result {
                case .success(let balance):
                    guard let value = BigInt(balance.drop0x, radix: 16) else {
                        return seal.reject(CookiesStoreError.empty)
                    }
                    seal.fulfill(value)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}

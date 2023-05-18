//
//  APICaller.swift
//  CryptoTrack
//
//  Created by Nazar Kopeyka on 20.04.2023.
//

import Foundation

final class APICaller { /* 1 */
    static let shared = APICaller() /* 2 */
    
    private struct Constants { /* 3 */
        static let apikey = "2365EB53-C1D2-4765-A671-1111698437C0" /* 4 */
        static let assetsEndpoint = "https://rest-sandbox.coinapi.io/v1/assets/" /* 7 */
    }
    private init() {} /* 5 */
    
    public var icons: [Icon] = [] /* 113 */
    
    private var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)? /* 117 to wait for icons to be returned */
    
    //MARK: - Public
    
    public func getAllCryptoData(
        completion: @escaping (Result<[Crypto], Error>) -> Void /* 41 change String to Crypto */
    ) { /* 6 */
        guard !icons.isEmpty else { /* 115 */
            whenReadyBlock = completion /* 118 */
            return /* 116 */
        }
        
        guard let url = URL(string: Constants.assetsEndpoint + "?apikey=" + Constants.apikey) else { /* 8 */
            return /* 9 */
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in /* 10 */
            guard let data = data, error == nil else { /* 11 */
                return /* 12 */
            }
            
            do { /* 13 */
                //Decode response
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data) /* 40 */
                completion(.success(cryptos.sorted { first, second -> Bool in
                    return first.price_usd ?? 0 > second.price_usd ?? 0
                })) /* 148 to sort by price */
//                completion(.success(cryptos)) /* 42 */
            }
            catch { /* 14 */
                completion(.failure(error)) /* 15 */
            }
        }
                           
        task.resume() /* 16 */
    }
    
    public func getAllIcons() { /* 105 */
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/32/?apikey=2365EB53-C1D2-4765-A671-1111698437C0") else { /* 106 */
            return /* 107 */
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in /* 108 copy from 10 and paste */ /* 111 add weak self */
            guard let data = data, error == nil else { /* 108 */
                return /* 108 */
            }
            
            do { /* 108 */
                self?.icons = try JSONDecoder().decode([Icon].self, from: data) /* 108 */
                if let completion = self?.whenReadyBlock { /* 119 */
                    self?.getAllCryptoData(completion: completion) /* 120 */
                }
            }
            catch { /* 108 */
                print(error) /* 112 */
            }
        }
                           
        task.resume() /* 108 */
    }
}

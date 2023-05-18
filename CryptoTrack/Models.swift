//
//  Models.swift
//  CryptoTrack
//
//  Created by Nazar Kopeyka on 20.04.2023.
//

import Foundation

struct Crypto: Codable { /* 38 */
    let asset_id: String /* 39 */
    let name: String? /* 39 */
    let price_usd: Float? /* 39 */
    let id_icon: String? /* 39 */
}

struct Icon: Codable { /* 109 */
    let asset_id: String /* 110 */
    let url: String /* 110 */
}

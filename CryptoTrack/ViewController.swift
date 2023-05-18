//
//  ViewController.swift
//  CryptoTrack
//
//  Created by Nazar Kopeyka on 20.04.2023.
//

import UIKit

//API caller
//UI to show different cryptos
//MVVM

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource { /* 37 add 2 protocols */

    private let tableView: UITableView = { /* 17 */
        let tableView = UITableView(frame: .zero, style: .grouped) /* 18 */
        tableView.register(CryptoTableViewCell.self,
                           forCellReuseIdentifier: CryptoTableViewCell.identifier) /* 21 */
        return tableView /* 19 */
    }()
    
    private var viewModels = [CryptoTableViewCellViewModel]() /* 82 */
    
    static let numberFormatter: NumberFormatter = { /* 94 */
        let formatter = NumberFormatter() /* 95 */
        formatter.locale = .current /* 96 */
        formatter.allowsFloats = true /* 97 */
        formatter.numberStyle = .currency /* 99 */
        formatter.formatterBehavior = .default /* 98 */
        return formatter /* 100 */
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crypto Tracker" /* 22 */
        view.addSubview(tableView) /* 23 */
        tableView.dataSource = self /* 24 */
        tableView.delegate = self /* 25 */
        
        APICaller.shared.getAllCryptoData { [weak self] result in /* 43 */ /* 83 add weak self*/
            switch result { /* 44 */
            case .success(let models): /* 45 */
                self?.viewModels = models.compactMap({ model in /* 84 */
                    //NumberFormatter
                    let price = model.price_usd ?? 0 /* 93 */
                    let formatter = ViewController.numberFormatter /* 101 */
                    let priceString = formatter.string(for: NSNumber(value: price)) /* 102 */
                    
                    let iconUrl = URL(string:
                                        APICaller.shared.icons.filter({ icon in /* 121 */
                                            icon.asset_id == model.asset_id /* 122 */
                                        }).first?.url ?? ""
                    ) /* 123 */
                    
                   return CryptoTableViewCellViewModel( /* 85 */ /* 104 add return */
                        name: model.name ?? "N/A",
                        symbol: model.asset_id,
                        price: priceString ?? "N/A", /* 103 change "$1" */
                        iconUrl: iconUrl /* 125 */
                   )
                })
                
                DispatchQueue.main.async { /* 88 */
                    self?.tableView.reloadData() /* 89 */
                }
                print(models.count) /* 46 */
            case .failure(let error): /* 45 */
                print("Error: \(error )") /* 47 */
            }
        }
    }

    override func viewDidLayoutSubviews() { /* 26 */
        super.viewDidLayoutSubviews() /* 27 */
        tableView.frame = view.bounds /* 28 */
    }
    
    //TableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /* 157 */
        tableView.deselectRow(at: indexPath, animated: true) /* 158 */
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 29 */
        return viewModels.count /* 30 */ /* 86  change 10 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 31 */
        guard let cell = tableView.dequeueReusableCell( /* 32 */
            withIdentifier: CryptoTableViewCell.identifier,
            for: indexPath
        ) as? CryptoTableViewCell else { /* 33 */
            fatalError() /* 34 */
        }
//        cell.textLabel?.text = "Hello world" /* 35 */
        cell.configure(with: viewModels[indexPath.row]) /* 87 */
        return cell /* 36 */
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { /* 90 */
        return 70 /* 91 */
    }
}


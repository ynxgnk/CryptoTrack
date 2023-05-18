//
//  CryptoTableViewCell.swift
//  CryptoTrack
//
//  Created by Nazar Kopeyka on 20.04.2023.
//

import UIKit

class CryptoTableViewCellViewModel { /* 48 */ /* 149 change from struct to class */
    let name: String /* 49 */
    let symbol: String /* 49 */
    let price: String /* 49 */
    let iconUrl: URL? /* 124 */
    var iconData: Data? /* 150 */
    
    init(
        name: String,
        symbol: String,
        price: String,
        iconUrl: URL?
    ) { /* 151 */
        self.name = name /* 152 */
        self.symbol = symbol /* 152 */
        self.price = price /* 152 */
        self.iconUrl = iconUrl /* 152 */
    }
}

class CryptoTableViewCell: UITableViewCell {
    static let identifier = "CryptoTableViewCell" /* 20 */

    //Subviews
    
    private let nameLabel: UILabel = { /* 55 */
        let label = UILabel() /* 56 */
        label.font = .systemFont(ofSize: 24, weight: .medium) /* 57 */
        return label /* 58 */
    }()
    
    private let symbolLabel: UILabel = { /* 59 */
        let label = UILabel() /* 60 */
        label.font = .systemFont(ofSize: 20, weight: .regular) /* 61 */
        return label /* 62 */
    }()
    
    private let priceLabel: UILabel = { /* 63 */
        let label = UILabel() /* 64 */
        label.textColor = .systemGreen /* 65 */
        label.textAlignment = .right /* 92 */
        label.font = .systemFont(ofSize: 22, weight: .semibold) /* 66 */
        return label /* 67 */
    }()
    
    private let iconImageView: UIImageView = { /* 126 */
        let imageView = UIImageView() /* 127 */
//        imageView.backgroundColor = .red /* 135 */
        imageView.contentMode = .scaleAspectFit /* 128 */
        return imageView /* 129 */
    }()
    
    //Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) { /* 51 */
        super.init(style: style, reuseIdentifier: reuseIdentifier) /* 52 */
        contentView.addSubview(nameLabel) /* 68 */
        contentView.addSubview(symbolLabel) /* 69 */
        contentView.addSubview(priceLabel) /* 70 */
        contentView.addSubview(iconImageView) /* 130 */
    }
    
    required init?(coder: NSCoder) { /* 53 */
        fatalError() /* 54 */
    }
    
    //Layout
    
    override func layoutSubviews() { /* 74 */
        super.layoutSubviews() /* 75 */
        
        let size: CGFloat = contentView.frame.size.height/1.1 /* 131 */
        iconImageView.frame = CGRect(
            x: 20,
            y: (contentView.frame.size.height-size)/2,
            width: size,
            height: size
        ) /* 132 */
        
        nameLabel.sizeToFit() /* 76 */
        priceLabel.sizeToFit() /* 77 */
        symbolLabel.sizeToFit() /* 78 */
        
        nameLabel.frame = CGRect(
            x: 30 + size, /* 133 add size */
            y: 0,
            width: contentView.frame.size.width/2,
            height: contentView.frame.size.height/2
        ) /* 79 */
        
        symbolLabel.frame = CGRect(
            x: 30 + size, /* 134 add size */
            y: contentView.frame.size.height/2,
            width: contentView.frame.size.width/2,
            height: contentView.frame.size.height/2
        ) /* 80 */
        
        priceLabel.frame = CGRect(
            x: contentView.frame.size.width/2,
            y: 0,
            width: (contentView.frame.size.width/2)-15,
            height: contentView.frame.size.height
        ) /* 81 */
    }
    
    override func prepareForReuse() { /* 142 lets every cell to nil itself out. Once its ready to be reused for the next cell */
        super.prepareForReuse() /* 143 */
        iconImageView.image = nil /* 144 */
        nameLabel.text = nil /* 145 */
        priceLabel.text = nil /* 146 */
        symbolLabel.text = nil /* 147 */
    }
    //Configure
    
    func configure(with viewModel: CryptoTableViewCellViewModel) { /* 50 */
        nameLabel.text = viewModel.name /* 71 */
        priceLabel.text = viewModel.price /* 72 */
        symbolLabel.text = viewModel.symbol /* 73 */
        
        if let data = viewModel.iconData { /* 154 */
            iconImageView.image = UIImage(data: data) /* 156 */
        }
        else if let url = viewModel.iconUrl { /* 136 */ /* 155 add else if */
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in /* 137 */
                if let data = data { /* 138 */
                    viewModel.iconData = data /* 153 */
                    DispatchQueue.main.async { /* 139 */
                        self?.iconImageView.image = UIImage(data: data) /* 140 */
                    }
                }
            }
                                                                         
            task.resume() /* 141 */
        }
    }
}

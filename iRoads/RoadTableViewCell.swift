//
//  RoadTableViewCell.swift
//  iRoads
//
//  Created by Любомир  Чорняк on 15.12.2023.
//

import UIKit

class RoadTableViewCell: UITableViewCell {
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lengthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let laneCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let isSeparatorPresentLabel: UILabel = {
        let label = UILabel()
        label.text = "Is separator present:"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let isSideWalkPresentLabel: UILabel = {
        let label = UILabel()
        label.text = "Is sidewalk present:"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let isSeparatorPresentImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 20))
        imageView.preferredSymbolConfiguration = config
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let isSideWalkPresentImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 20))
        imageView.preferredSymbolConfiguration = config
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private enum UIConstants {
        static let symbolSize: CGFloat = 30
        static let labelHeight: CGFloat = 32
    }
    
    static let cellHeight: CGFloat = 290

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        contentView.addSubview(shadowView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(lengthLabel)
        contentView.addSubview(laneCountLabel)
        contentView.addSubview(isSeparatorPresentLabel)
        contentView.addSubview(isSideWalkPresentLabel)
        contentView.addSubview(isSeparatorPresentImageView)
        contentView.addSubview(isSideWalkPresentImageView)
        
        setupConstraints()

    }
    
    private let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.5
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 17, bottom: 10, right: 17))
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = false
    }
    
    func configureCell(with type: Road.RoadType, length: Int, laneCount: Int, isSeparatorPresent: Bool, isSideWalkPresent: Bool) {
        
        let font: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 30, weight: .medium)]
        let color1: [NSAttributedString.Key: Any]  = [.foregroundColor : UIColor.secondaryLabel]
        let color2: [NSAttributedString.Key: Any]  = [.foregroundColor: UIColor.label]
        
        let typeString = "Type: \(type.rawValue)"
        let typeAttributedString = NSMutableAttributedString(string: typeString)
        typeAttributedString.addAttributes(font, range: NSRange(location: 0, length: typeString.count ))
        typeAttributedString.addAttributes(color1, range: NSRange(location: 0, length: "Type: ".count))
        typeAttributedString.addAttributes(color2, range: NSRange(location: "Type: ".count, length: type.rawValue.count))
        typeLabel.attributedText = typeAttributedString
        
        let lengthString = "Length: \(length)"
        let lengthAttributedString = NSMutableAttributedString(string: lengthString)
        lengthAttributedString.addAttributes(font, range: NSRange(location: 0, length: lengthString.count))
        lengthAttributedString.addAttributes(color1, range: NSRange(location: 0, length: "Type: ".count))
        lengthAttributedString.addAttributes(color2, range: NSRange(location: "Length: ".count, length: "\(length)".count))
        lengthLabel.attributedText = lengthAttributedString
        
        let laneCountString = "Amount of lanes: \(laneCount)"
        let laneCountAttributedString = NSMutableAttributedString(string: laneCountString)
        laneCountAttributedString.addAttributes(font, range: NSRange(location: 0, length: laneCountString.count))
        laneCountAttributedString.addAttributes(color1, range: NSRange(location: 0, length: "Amount of lanes: ".count))
        laneCountAttributedString.addAttributes(color2, range: NSRange(location: "Amount of lanes: ".count, length: "\(laneCount)".count))
        laneCountLabel.attributedText = laneCountAttributedString
    
        
        let checkmarkImage = UIImage(systemName: "checkmark")
        checkmarkImage?.applyingSymbolConfiguration(.init(font: .boldSystemFont(ofSize: 40)))
        let xmarkImage = UIImage(systemName: "xmark")
        xmarkImage?.applyingSymbolConfiguration(.init(font: .boldSystemFont(ofSize: 40)))
        
        isSeparatorPresentImageView.image = isSeparatorPresent ? checkmarkImage : xmarkImage
        isSeparatorPresentImageView.tintColor = isSeparatorPresent ? .yellow : .red
        
        isSideWalkPresentImageView.image = isSideWalkPresent ? checkmarkImage : xmarkImage
        isSideWalkPresentImageView.tintColor = isSideWalkPresent ? .yellow : .red
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            
            typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            typeLabel.heightAnchor.constraint(equalToConstant: UIConstants.labelHeight),
            
            
            lengthLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 20),
            lengthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lengthLabel.heightAnchor.constraint(equalToConstant: UIConstants.labelHeight),

            
            laneCountLabel.topAnchor.constraint(equalTo: lengthLabel.bottomAnchor, constant: 20),
            laneCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            laneCountLabel.heightAnchor.constraint(equalToConstant: UIConstants.labelHeight),

            isSeparatorPresentLabel.topAnchor.constraint(equalTo: laneCountLabel.bottomAnchor, constant: 20),
            isSeparatorPresentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            isSeparatorPresentLabel.heightAnchor.constraint(equalToConstant: UIConstants.labelHeight),

            
            isSideWalkPresentLabel.topAnchor.constraint(equalTo: isSeparatorPresentLabel.bottomAnchor, constant: 20),
            isSideWalkPresentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            isSideWalkPresentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            isSideWalkPresentLabel.heightAnchor.constraint(equalToConstant: UIConstants.labelHeight),

            
            isSeparatorPresentImageView.centerYAnchor.constraint(equalTo: isSeparatorPresentLabel.centerYAnchor),
            isSeparatorPresentImageView.leadingAnchor.constraint(equalTo: isSeparatorPresentLabel.trailingAnchor, constant: 10),
            isSeparatorPresentImageView.heightAnchor.constraint(equalToConstant: UIConstants.symbolSize),
            isSeparatorPresentImageView.widthAnchor.constraint(equalToConstant: UIConstants.symbolSize),

            
            isSideWalkPresentImageView.centerYAnchor.constraint(equalTo: isSideWalkPresentLabel.centerYAnchor),
            isSideWalkPresentImageView.leadingAnchor.constraint(equalTo: isSeparatorPresentImageView.leadingAnchor),
            isSideWalkPresentImageView.heightAnchor.constraint(equalToConstant: UIConstants.symbolSize),
            isSideWalkPresentImageView.widthAnchor.constraint(equalToConstant: UIConstants.symbolSize)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

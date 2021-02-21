//
//  RunwayCell.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/9/21.
//

import SwiftUI
import UIKit

class RunwayCell: UITableViewCell {
    static let reuseId = "RunwayCell"

    let separatorLine = UIView()

    let runwayTitleLabel = AMPrimaryLabel(text: "Wedding Outfit 2021", fontSize: 20)
    let favoriteImageView = UIImageView(image: UIImage(systemName: SFSymbol.starFill)?.withRenderingMode(.alwaysOriginal))
    let runwayDateLabel = AMBodyLabel(text: "Last updated on 2/2/2020", fontSize: 9)
    let runwayStatusLabel = AMBodyLabel(text: "Status: Not Sharing", fontSize: 9)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(runway: Runway) {
        runwayTitleLabel.text = runway.title
        updateStatusLabel(isSharing: runway.isSharing)

        if let starImage = UIImage(systemName: SFSymbol.starFill) {
            let starColor = runway.isFavorite ? UIColor.systemYellow : UIColor.systemGray
            favoriteImageView.image = starImage.withRenderingMode(.alwaysOriginal).withTintColor(starColor)
        }

        if let date = runway.dateUpdated {
            let dateString = date.convertToDayMonthYearFormat()
            runwayDateLabel.text = "Last updated on \(dateString)"
        } else {
            let dateString = runway.dateCreated.convertToDayMonthYearFormat()
            runwayDateLabel.text = "Created on \(dateString)"
        }
    }

    private func configureCell() {
        addSeparatorLine()
        configureFavoriteImageView()
        configureRunwayTitleLabel()
        configureRunwayStatusLabel()
        configureRunwayDateLabel()
    }

    private func configureFavoriteImageView() {
        addSubview(favoriteImageView)

        favoriteImageView.snp.makeConstraints { make in
            make.right.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.top.equalTo(self).offset(8)
        }
    }

    private func configureRunwayTitleLabel() {
        addSubview(runwayTitleLabel)

        runwayTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.centerY.equalTo(favoriteImageView)
        }
    }

    private func configureRunwayStatusLabel() {
        addSubview(runwayStatusLabel)

        runwayStatusLabel.snp.makeConstraints { make in
            make.left.equalTo(runwayTitleLabel)
            make.bottom.equalTo(separatorLine).offset(-12)
        }
    }

    private func configureRunwayDateLabel() {
        addSubview(runwayDateLabel)
        runwayDateLabel.setFont(with: UIFont(name: Fonts.quicksandRegular, size: 9))
        runwayDateLabel.textColor = .secondaryLabel

        runwayDateLabel.snp.makeConstraints { make in
            make.right.equalTo(favoriteImageView)
            make.bottom.equalTo(separatorLine).offset(-12)
        }
    }

    private func addSeparatorLine() {
        addSubview(separatorLine)
        separatorLine.backgroundColor = UIColor.customSeparator

        separatorLine.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(4)
        }
    }

    func updateStatusLabel(isSharing: Bool) {
        let customFont = UIFont(name: Fonts.quicksandMedium, size: 9)!

        let statusAttributedText = NSMutableAttributedString(string: "Status: ", attributes: [
            NSAttributedString.Key.font: UIFontMetrics.default.scaledFont(for: customFont),
        ])

        let valueAttributedText = NSAttributedString(string: isSharing ? "Sharing" : "Not Sharing", attributes: [
            NSAttributedString.Key.font: UIFontMetrics.default.scaledFont(for: customFont),
            NSAttributedString.Key.foregroundColor: isSharing ? UIColor.systemGreen : UIColor.systemRed
        ])

        statusAttributedText.append(valueAttributedText)
        runwayStatusLabel.attributedText = statusAttributedText
    }
}

#if DEBUG
struct RunwayCellPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewPreview { RunwayCell() }
            UIViewPreview { RunwayCell() }
                .environment(\.sizeCategory, .extraExtraExtraLarge)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 70)
    }
}
#endif

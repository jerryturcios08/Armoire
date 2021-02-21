//
//  DangerButtonCell.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/20/21.
//

import SwiftUI
import UIKit

class DangerButtonCell: UITableViewCell {
    static let reuseId = "DangerButtonCell"

    let dangerButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(title: String, textAlignment: NSTextAlignment) {
        dangerButton.setTitle(title, for: .normal)
        dangerButton.titleLabel?.textAlignment = textAlignment
    }

    private func configureCell() {
        configureDangerButton()
    }

    private func configureDangerButton() {
        addSubview(dangerButton)
        dangerButton.setTitleColor(.systemRed, for: .normal)
        dangerButton.snp.makeConstraints { $0.center.equalTo(self) }
    }
}

#if DEBUG
struct DangerButtonCellPreviews: PreviewProvider {
    static var dangerButton: DangerButtonCell {
        let cell = DangerButtonCell()
        cell.set(title: "Delete Account", textAlignment: .center)
        return cell
    }

    static var previews: some View {
        UIViewPreview { dangerButton }
            .previewLayout(.sizeThatFits)
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 44)
    }
}
#endif

//
//  ButtonTableViewCell.swift
//  Task
//
//  Created by Jordan Lamb on 9/25/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit


protocol ButtonTableViewCellDelegate {
    func buttonCellButtonTapped (_ sender: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {

    var delegate: ButtonTableViewCellDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var isPurchasedButton: UIButton!
    
    // MARK: - Actions
    @IBAction func checkMarkButtonTapped(_ sender: Any) {
        delegate?.buttonCellButtonTapped(self)
    }
    
    fileprivate func updateButton(_ isPurchased: Bool) {
        let imageName = isPurchased ? "purchased" : "notpurchased"
        isPurchasedButton.setImage(UIImage(named: imageName), for: .normal)
    }
}

extension ButtonTableViewCell {
    func update(shopping: Shopping) {
        itemNameLabel.text = shopping.itemName
        updateButton(shopping.isPurchased)
    }
}

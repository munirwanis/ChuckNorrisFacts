//
//  FactTableViewCell.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 21/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class FactTableViewCell: UITableViewCell {
    @IBOutlet private var factImage: UIImageView!
    @IBOutlet private var factLabel: UILabel!

    private let bag = DisposeBag()

    var fact: FactPresentation? {
        didSet {
            guard let fact = fact else { return }
            factLabel.font.withSize(fact.textSize)
            factLabel.text = fact.factText
            fact.imageObservable
                .subscribe(onNext: { [weak self] image in
                    self?.factImage.image = image
                })
                .disposed(by: self.bag)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

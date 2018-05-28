//
//  LoadingCell.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 28/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import UIKit

final class LoadingCell: UITableViewCell {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    func animateLoading() {
        self.activityIndicator.startAnimating()
    }
}

//
//  ListFactsTableViewController.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 20/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class ListFactsTableViewController: UITableViewController {

    private let bag = DisposeBag()

    private let viewModel: ListFactsViewModel = {
        ListFactsViewModel()
    }()

    private lazy var alertViewController: UIAlertController = {
        let alertView = UIAlertController(title: "Pesquisa", message: nil, preferredStyle: .alert)
        alertView.addTextField { textField in
            textField.placeholder = "Digite o termo a ser pesquisado..."
            self.termToBeSearchedTextField = textField
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { _ in
            alertView.dismiss(animated: true, completion: nil)
        }
        alertView.addAction(cancelAction)
        let searchAction = UIAlertAction(title: "Pesquisar", style: .default) { _ in
            guard let text = self.termToBeSearchedTextField?.text else { return }
            self.viewModel.getFacts(term: text)
            self.termToBeSearchedTextField?.text = ""
        }
        alertView.addAction(searchAction)
        return alertView
    }()
    
    private var termToBeSearchedTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.currentState
            .subscribe(onNext: { state in
                switch state {
                case .success(let facts): self.bindCards(with: facts)
                case .empty: self.bindCard(identifier: "EmptyFactsCell", with: state)
                case .loading: self.bindCard(identifier: LoadingCell.identifier, with: state)
                case .waitingForInput: self.bindCard(identifier: "WaitingInputCell", with: state)
                case .error(let error): self.bindCard(with: error)
                }
            }, onError: { error in
                self.bindCard(with: error)
            })
            .disposed(by: self.bag)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? LoadingCell {
            cell.animateLoading()
        }
    }
}

// MARK: - Action methods

extension ListFactsTableViewController {
    @IBAction private func didPressActionButton(_ sender: UIBarButtonItem) {
        present(self.alertViewController, animated: true, completion: nil)
    }
}

// MARK: - Private methods

private extension ListFactsTableViewController {
    func bindCard(identifier: String, with state: Any) {
        Observable.of([state])
            .bind(to: self.tableView.rx.items(cellIdentifier: identifier)) { _, _, _ in }
            .disposed(by: self.bag)
    }

    func bindCard(with error: Error) {
        if let cnError = error as? CNError {
            switch cnError {
            case .networkError: bindCard(identifier: "NoConnectionCell", with: error)
            default: bindCard(identifier: "GeneralErrorCell", with: error)
            }
        } else {
            bindCard(identifier: "GeneralErrorCell", with: error)
        }
    }
    
    func bindCards(with facts: FactsPresentation) {
        Observable.of(facts)
            .bind(to: self.tableView.rx
                .items(cellIdentifier: FactTableViewCell.identifier,
                       cellType: FactTableViewCell.self)) { _, fact, cell in
                        cell.fact = fact
            }
            .disposed(by: self.bag)
    }
}

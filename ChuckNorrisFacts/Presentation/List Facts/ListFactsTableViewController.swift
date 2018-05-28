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

class ListFactsTableViewController: UITableViewController {

    private let bag = DisposeBag()

    private let viewModel: ListFactsViewModel = {
        ListFactsViewModel()
    }()

    private var termToBeSearchedTextField: UITextField?

    private func showView<T: UIView>(of type: T.Type, among views: [UIView]) {
        views.forEach { view in
            view.alpha = view is T ? 1 : 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        viewModel.currentState
            .asObservable()
            .subscribe(onNext: { state in
                print(state)
            }, onError: { error in
                print(error)
            })
            .disposed(by: self.bag)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FactTableViewCell.identifier, for: indexPath)
//        _ = viewModel.presentation
//            .bind(to: tableView.rx.items(
//                cellIdentifier: FactTableViewCell.identifier,
//                cellType: FactTableViewCell.self)) { index, facts, cell in
//
//
//        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: - Action methods

extension ListFactsTableViewController {
    @IBAction private func didPressActionButton(_ sender: UIBarButtonItem) {
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
            // TODO: Logic
            print(self.termToBeSearchedTextField?.text ?? "No term")
        }
        alertView.addAction(searchAction)

        present(alertView, animated: true, completion: nil)
    }
}

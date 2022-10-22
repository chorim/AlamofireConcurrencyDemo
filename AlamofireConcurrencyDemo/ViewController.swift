//
//  ViewController.swift
//  AlamofireConcurrencyDemo
//
//  Created by Insu Byeon on 2022/02/24.
//

import UIKit

struct Joke: Codable {
  let type: String
  let value: [Value]
  
  struct Value: Codable {
    let id: Int
    let joke: String
  }
}

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  private var jokes: [Joke.Value] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    
    Task {
      await retrieveJokes()
    }
  }
  
  private func retrieveJokes() async {
    do {
      let joke = try await AppNetworking.shared.requestJSON("https://api.icndb.com/jokes/random/50",
                                                             type: Joke.self,
                                                             method: .get,
                                                             parameters: nil)
      updateUI(jokes: joke.value)
    } catch {
      updateUI(error: error)
    }
  }
  
  @MainActor
  private func updateUI(error: Error) {
    let label = UILabel()
    label.numberOfLines = 0
    label.text = error.localizedDescription
    label.frame = view.bounds
    view.addSubview(label)
  }
  
  @MainActor
  private func updateUI(jokes: [Joke.Value]) {
    self.jokes = jokes
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
     return 1
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return jokes.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = jokes[indexPath.row].joke
    cell.textLabel?.numberOfLines = 0
    return cell
  }
}


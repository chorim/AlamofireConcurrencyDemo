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
}

struct Value: Codable {
  let id: Int
  let joke: String
}

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  private var jokes: [Value] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    
    Task {
      try? await fetch()
      updateUI()
    }
  }
  
  private func fetch() async throws {
    let joke = try? await AppNetworking.shared.requestJSON("https://api.icndb.com/jokes/random/50",
                                                           type: Joke.self,
                                                           method: .get,
                                                           parameters: nil)
    guard let value = joke?.value else { return }
    jokes = value
  }
  
  @MainActor
  private func updateUI() {
    assert(Thread.isMainThread == Thread.isMultiThreaded(),
           "UI 업데이트는 메인 스레드에서 실행되어야 합니다.")
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


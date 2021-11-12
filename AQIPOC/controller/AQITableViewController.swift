//
//  AQITableViewController.swift
//  AQIPOC
//
//  Created by User on 10/24/21.
//

import UIKit



class AQITableViewController: UITableViewController {
    
    let viewModel = AQITableViewModel(with: Constant.fullCityList)
    var selectedIndex: IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "City List"
        viewModel.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        viewModel.startDataPoll()
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopDataPoll()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AQITableViewCell", for: indexPath)
        let element = viewModel.defaultCitiesList[indexPath.row]
        if let aqiCell = cell as? AQITableViewCell {
            aqiCell.configurView(with: element)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        self.performSegue(withIdentifier: "datapointGraphPlot", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let element = viewModel.defaultCitiesList[selectedIndex.row]
        let graphViewModel = AQIGraphViewModel(with: [element.city])
        if let controller = segue.destination as? GraphViewController {
            controller.viewModel = graphViewModel
        }
    }

    deinit {
        viewModel.delegate = nil
    }
}

extension AQITableViewController: ViewModelDelegate {
    func viewModelDidUpdate() {
        tableView.reloadData()
    }

    func viewModelUpdateFailed(error: AQIError) {
        print(error.description)
    }
}

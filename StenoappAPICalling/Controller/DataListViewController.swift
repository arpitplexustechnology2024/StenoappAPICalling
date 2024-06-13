//
//  DataListViewController.swift
//  StenoappAPICalling
//
//  Created by Arpit iOS Dev. on 12/06/24.
//

import UIKit
import Alamofire

class DataListViewController: UIViewController {
    
    @IBOutlet weak var dataListTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var dataList = [SubDataList]()
    var subCategoryID: String!
    var categoryID: String!
    var noInternetView: NoInternetView!
    var noDataView: NoDataView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dataListTableView.delegate = self
        dataListTableView.dataSource = self
        dataListTableView.isHidden = true
        self.dataListTableView.register(UINib(nibName: "stenoTableViewCell", bundle: nil), forCellReuseIdentifier: "stenoTableViewCell")
        self.dataListTableView.register(UINib(nibName: "DataListTableViewCell", bundle: nil), forCellReuseIdentifier: "DataListTableViewCell")
        
        setupNoInternetView()
        setupNoDataView()
        
        if let _ = categoryID {
            if isConnectedToInternet() {
                self.showLoaderAndFetchData(categoryID: self.categoryID, subCategoryID: self.subCategoryID)
            } else {
                showNoInternetView()
            }
        }
    }
    
    func setupNoInternetView() {
        noInternetView = NoInternetView()
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        noInternetView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        view.addSubview(noInternetView)
        
        NSLayoutConstraint.activate([
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.topAnchor.constraint(equalTo: view.topAnchor),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        noInternetView.isHidden = true
    }
    
    func setupNoDataView() {
        noDataView = NoDataView()
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noDataView)
        
        NSLayoutConstraint.activate([
            noDataView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noDataView.topAnchor.constraint(equalTo: view.topAnchor),
            noDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        noDataView.isHidden = true
    }
    
    @objc func retryButtonTapped() {
        if isConnectedToInternet() {
            noInternetView.isHidden = true
            self.showLoaderAndFetchData(categoryID: self.categoryID, subCategoryID: self.subCategoryID)
        } else {
            showAlert(title: "No Internet", message: "Please check your internet connection and try again.")
        }
    }
    
    func showLoaderAndFetchData(categoryID: String, subCategoryID: String) {
        activityIndicator.startAnimating()
        activityIndicator.style = .large
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.activityIndicator.stopAnimating()
            self.dataListTableView.isHidden = false
            // Background thread
            DispatchQueue.global(qos: .background).async {
                self.fetchDocuments(categoryID: self.categoryID, subCategoryID: self.subCategoryID)
            }
        }
    }
    
    func fetchDocuments(categoryID: String, subCategoryID: String) {
        let url = "http://stenoapp.gautamsteno.com/api/get_docs_list"
        let parameters: [String: String] = ["category_id": categoryID, "subcat_id": subCategoryID]
        
        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).responseJSON { response in
            switch response.result {
            case .success(let dataListResponse):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: dataListResponse)
                    let dataListResponse = try JSONDecoder().decode(DataList.self, from: jsonData)
                    if dataListResponse.status == 1 && !dataListResponse.data.isEmpty {
                        self.dataList = dataListResponse.data
                        // Update the UI on the main thread
                        DispatchQueue.main.async {
                            self.dataListTableView.reloadData()
                        }
                    } else {
                        // No data found
                        DispatchQueue.main.async {
                            self.showNoDataView()
                        }
                    }
                } catch {
                    // No data found
                    DispatchQueue.main.async {
                        self.showNoDataView()
                    }
                }
            case .failure(let error):
                print("Error occurred: \(error)")
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func isConnectedToInternet() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return networkManager?.isReachable ?? false
    }
    
    func showNoInternetView() {
        noInternetView.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    func showNoDataView() {
        noDataView.isHidden = false
        dataListTableView.isHidden = true
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView Dalegate & Datasource
extension DataListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "stenoTableViewCell") as! stenoTableViewCell
            
            return Cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataListTableViewCell") as! DataListTableViewCell
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.white
            } else {
                cell.backgroundColor = UIColor.customeGray
            }
            let datum = dataList[indexPath.row]
            cell.idLbl.text = "\(indexPath.row)"
            cell.nameLbl.text = datum.name
            switch datum.extPath {
            case .pdf:
                cell.extPathIcon.image = UIImage(named: "pdf")
            case .mp3:
                cell.extPathIcon.image = UIImage(named: "mp3")
            default:
                cell.extPathIcon.image = nil
            }
            switch datum.extPath1 {
            case .pdf:
                cell.extPath1Icon.image = UIImage(named: "pdf")
            case .mp3:
                cell.extPath1Icon.image = UIImage(named: "mp3")
            default:
                cell.extPath1Icon.image = nil
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 57
        } else {
            return 65
        }
    }
}

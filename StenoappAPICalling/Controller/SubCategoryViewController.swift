//
//  SubCategoryViewController.swift
//  StenoappAPICalling
//
//  Created by Arpit iOS Dev. on 12/06/24.
//

import UIKit
import Alamofire

class SubCategoryViewController: UIViewController {
    
    @IBOutlet weak var subCategoryTableView: UITableView!
    @IBOutlet weak var subategoryView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var categoryID: String!
    var subCategories: [Datum] = []
    var noInternetView: NoInternetView!
    var noDataView: NoDataView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subCategoryTableView.delegate = self
        subCategoryTableView.dataSource = self
        subCategoryTableView.isHidden = true
        subategoryView.layer.cornerRadius = 30
        subategoryView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setupNoInternetView()
        setupNoDataView()
        
        if let _ = categoryID {
            if isConnectedToInternet() {
                self.showLoaderAndFetchData(categoryID: self.categoryID)
            } else {
                showNoInternetView()
            }
        }
    }
    
    func setupNoInternetView() {
        noInternetView = NoInternetView()
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        noInternetView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        subategoryView.addSubview(noInternetView)
        
        NSLayoutConstraint.activate([
            noInternetView.leadingAnchor.constraint(equalTo: subategoryView.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: subategoryView.trailingAnchor),
            noInternetView.topAnchor.constraint(equalTo: subategoryView.topAnchor),
            noInternetView.bottomAnchor.constraint(equalTo: subategoryView.bottomAnchor)
        ])
        
        noInternetView.isHidden = true
    }
    
    func setupNoDataView() {
        noDataView = NoDataView()
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        subategoryView.addSubview(noDataView)
        
        NSLayoutConstraint.activate([
            noDataView.leadingAnchor.constraint(equalTo: subategoryView.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: subategoryView.trailingAnchor),
            noDataView.topAnchor.constraint(equalTo: subategoryView.topAnchor),
            noDataView.bottomAnchor.constraint(equalTo: subategoryView.bottomAnchor)
        ])
        
        noDataView.isHidden = true
    }
    
    @objc func retryButtonTapped() {
        if isConnectedToInternet() {
            noInternetView.isHidden = true
            self.showLoaderAndFetchData(categoryID: self.categoryID)
        } else {
            showAlert(title: "No Internet", message: "Please check your internet connection and try again.")
        }
    }
    
    func showLoaderAndFetchData(categoryID: String) {
        activityIndicator.startAnimating()
        activityIndicator.style = .large
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.activityIndicator.stopAnimating()
            self.subCategoryTableView.isHidden = false
            // Background thread
            DispatchQueue.global(qos: .background).async {
                self.fetchSubCategories(categoryID: self.categoryID)
            }
        }
    }
    
    func fetchSubCategories(categoryID: String) {
        let url = "http://stenoapp.gautamsteno.com/api/get_all_sub_category"
        let parameters: [String: String] = ["category_id": categoryID]
        
        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).responseDecodable(of: SubCategory.self) { response in
            switch response.result {
            case .success(let subCategoryResponse):
                if subCategoryResponse.status == 1 {
                    self.subCategories = subCategoryResponse.data
                    DispatchQueue.main.async {
                        self.subCategoryTableView.reloadData()
                    }
                } else {
                    print("Failed to fetch subcategories: Status \(subCategoryResponse.status)")
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.noDataView.isHidden = false
                }
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
        subCategoryTableView.isHidden = true
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView Dalegate & Datasource
extension SubCategoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTableViewCell") as! SubCategoryTableViewCell
        let subCategory = subCategories[indexPath.row]
        cell.dataLbl.text = subCategory.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = subCategories[indexPath.item]
        navigateToSubCategoryViewController(subCategoryID: selectedData.subCategoryID)
    }
    
    func navigateToSubCategoryViewController(subCategoryID: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DataListViewController") as! DataListViewController
        vc.categoryID = self.categoryID
        vc.subCategoryID = subCategoryID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let rotationTranform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
//        cell.layer.transform = rotationTranform
//        cell.alpha = 1.0
//        
//        UIView.animate(withDuration: 1.0) {
//            cell.layer.transform = CATransform3DIdentity
//            cell.alpha = 1.0
//        }
//    }
}

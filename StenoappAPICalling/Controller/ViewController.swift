//
//  ViewController.swift
//  StenoappAPICalling
//
//  Created by Arpit iOS Dev. on 12/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    var imageArr = [HomeUserData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        
        imageArr = [
            HomeUserData(image: "home1", id: "8"),
            HomeUserData(image: "home2", id: "15"),
            HomeUserData(image: "home3", id: "10"),
            HomeUserData(image: "home4", id: "12"),
            HomeUserData(image: "home5", id: "14"),
            HomeUserData(image: "home6", id: "11"),
            HomeUserData(image: "home7", id: "13"),
            HomeUserData(image: "home8", id: "9"),
            HomeUserData(image: "home9", id: "20")
        ]
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.homeImageView.image = UIImage(named: imageArr[indexPath.row].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedData = imageArr[indexPath.item]
        navigateToSubCategoryViewController(categoryID: selectedData.id)
    }
    
    func navigateToSubCategoryViewController(categoryID: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
        vc.categoryID = categoryID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.height/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//
//  ProductDetailsVC.swift
//  El_DUKKANA
//
//  Created by ios on 06/09/2024.
//

import UIKit
import Kingfisher

class ProductDetailsVC: UIViewController {

    @IBOutlet weak var addCartBtn: UIButton!
    @IBOutlet weak var descriptionLbl: UITextView!
    @IBOutlet weak var color3Lbl: UILabel!
    @IBOutlet weak var color2Lbl: UILabel!
    @IBOutlet weak var color1Lbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var productCollectionView: UICollectionView!
    var pageCont = PageController()
    var viewModel = ProductDetailsViewModel()
    var timer : Timer?
    var currentCellIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        
        viewModel.getData()
        viewModel.bindResultToViewController = {
            self.pageController.numberOfPages = self.viewModel.product?.product.images?.count ?? 1
            self.pageController.currentPage = 0
            if let product = self.viewModel.product?.product{
                self.descriptionLbl.text = product.body_html ?? ""
                self.productTitleLbl.text = product.title ?? ""
                self.color1Lbl.text = product.variants?[0].option1 ?? ""
                self.color2Lbl.text = product.variants?[0].option2 ?? ""
                self.color3Lbl.text = product.variants?[0].option3 ?? ""
                self.brandLbl.text = product.vendor ?? ""
                self.priceLbl.text = "\(product.variants?[0].price ?? "5") USD"
            }
            self.productCollectionView.reloadData()
        }
        let productLayout = UICollectionViewCompositionalLayout() {
            indexPath,environment in
            return DrawCollectioView.drawSection()
        }
        productCollectionView.setCollectionViewLayout(productLayout, animated: true)
       // addCartBtn.layer.cornerRadius = addCartBtn.frame.width - 10
        

    }
    @IBAction func addToCartBtn(_ sender: Any) {
    }
    
    @objc func moveToNextIndex(){
        pageCont.moveNextIndex(specificCount: viewModel.product?.product.images?.count ?? 1, specificCollectionView: productCollectionView, pageController: pageController)
    }
    
    @IBAction func showReviewsBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ReviewsViewController") as? ReviewsViewController
        if let viewController = vc {
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
            
        }
    }
    
}

extension ProductDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.product?.product.images?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductImagesCell
        
        cell.productImage.kf.setImage(with: URL(string: viewModel.product?.product.images![indexPath.row].src ?? "Sam"))
            
        return cell
    }
    
    
}

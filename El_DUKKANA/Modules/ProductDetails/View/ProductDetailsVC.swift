//
//  ProductDetailsVC.swift
//  El_DUKKANA
//
//  Created by ios on 06/09/2024.
//

import UIKit
import Kingfisher

class ProductDetailsVC: UIViewController {

   
    
    @IBOutlet weak var colorsSegmented: UISegmentedControl!
    @IBOutlet weak var addCartBtn: UIButton!{
        didSet{
            ViewsSet.btnSet(btn: addCartBtn)
        }
    }
    @IBOutlet weak var descriptionLbl: UITextView!
    
   
    @IBOutlet weak var sizeSegmentedController: UISegmentedControl!
    
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
        print("Finally We Did IT : \(CurrentCustomer.currentCustomer)")
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
        
            for option in product.options ?? [] {
                    if option.name == "Color" {
                        // Set up color segments
                        self.configureSegmentedControl(self.colorsSegmented, with: option.values)
                    } else if option.name == "Size" {
                        // Set up size segments
                        self.configureSegmentedControl(self.sizeSegmentedController, with: option.values)
                    }
                        }
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
        if CurrentCustomer.currentCustomer.email != nil {
            if let product = viewModel.product?.product{
                let productToCart = LineItem(id: 7482947, variant_id: product.variants?[0].id, product_id: viewModel.productId, title: product.title, variant_title: product.variants?[0].title, vendor: product.vendor, quantity: 1, name: "", custom: false, price: product.variants?[0].price,properties: [(ProductProperties(image: product.image?.src ?? ""))])
                print("\n\nold cart : \(CurrentCustomer.currentCartDraftOrder.draft_order.line_items)\n\n")
                CurrentCustomer.currentCartDraftOrder.draft_order.line_items.append(productToCart)
                CurrentCustomer.currentCartDraftOrder.draft_order.line_items.removeAll { $0.price == "70.00" }

                
                let alert = UIAlertController(title: "Product Added to cart", message: "the product has been added to cart succesfully", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { action in
                    print("\n\n current cart : \(CurrentCustomer.currentCartDraftOrder.draft_order.line_items)\n")
                    
                    self.viewModel.updateCartDraftOrder()
                    print("\n\n\n\nUpdate Draft Order After Put : \(CurrentCustomer.currentCartDraftOrder)\n\n\n\n")
                }
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
            
            
        }else {
            let alert = UIAlertController(title: "SignIn First", message: "You can't add to cart you have to sign in first", preferredStyle: .alert)
            let signIn = UIAlertAction(title: "SignIn", style: .default) { action in
                let storyBoard = UIStoryboard(name: "AuthenticationStoryboard", bundle: nil)
                if let vc = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC {
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
                let cancle = UIAlertAction(title: "Cancle", style: .cancel)
            alert.addAction(signIn)
            alert.addAction(cancle)
            
            self.present(alert, animated: true)
            
        }
    }
    
    @objc func moveToNextIndex(){
        pageCont.moveNextIndex(specificCount: viewModel.product?.product.images?.count ?? 1, specificCollectionView: productCollectionView, pageController: pageController)
    }
    
    @IBAction func addToFavBtnAction(_ sender: Any) {
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func showReviewsBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ReviewsViewController") as? ReviewsViewController
        if let viewController = vc {
            vc?.viewModel.images = viewModel.product?.product.images ?? []
            vc?.viewModel.title = viewModel.product?.product.title ?? ""
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
            
        }
    }
    //segmented Function
    func configureSegmentedControl(_ segmentedControl: UISegmentedControl, with values: [String]?) {
            guard let values = values else { return }
            
            for index in 0..<segmentedControl.numberOfSegments {
                if index < values.count {
                    segmentedControl.setTitle(values[index], forSegmentAt: index)
                    segmentedControl.setEnabled(true, forSegmentAt: index) // Enable the segment if a value is present
                } else {
                    segmentedControl.setEnabled(false, forSegmentAt: index) // Disable the segment if no value
                }
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

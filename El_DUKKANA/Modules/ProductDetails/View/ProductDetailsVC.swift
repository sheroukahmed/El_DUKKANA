//
//  ProductDetailsVC.swift
//  El_DUKKANA
//
//  Created by ios on 06/09/2024.
//

import UIKit
import Kingfisher

class ProductDetailsVC: UIViewController {

   
    
    @IBOutlet weak var addToFavBtn: UIButton!
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
    var forFavBtn = FavBtnAnimation()
    var pageCont = PageController()
    var viewModel = ProductDetailsViewModel()
    var favViewModel = FavoritesViewModel()
    var timer : Timer?
    var currentCellIndex = 0
    var isFavorated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Finally We Did IT : \(CurrentCustomer.currentCustomer)")
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        forFavBtn.setFavouriteButton(btn: addToFavBtn)
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
            if self.viewModel.product?.product.title != nil{
                for item in CurrentCustomer.currentFavDraftOrder.draft_order.line_items{
                    if self.viewModel.product?.product.title == item.title {
                        self.isFavorated = true
                        break
                    }else{
                        self.isFavorated = false
                    }
                }
            }
            self.setBtnView()
            self.productCollectionView.reloadData()
        }
        let productLayout = UICollectionViewCompositionalLayout() {
            indexPath,environment in
            return DrawCollectioView.drawSection()
        }
        productCollectionView.setCollectionViewLayout(productLayout, animated: true)
       // addCartBtn.layer.cornerRadius = addCartBtn.frame.width - 10
        

    }
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    @IBAction func addToCartBtn(_ sender: Any) {
        if CurrentCustomer.currentCustomer.email != nil {
            if self.colorsSegmented.selectedSegmentIndex != -1 && self.sizeSegmentedController.selectedSegmentIndex != -1{
                if let product = viewModel.product?.product{
                    let productToCart = LineItem(id: 7482947, variant_id: product.variants?[0].id, product_id: viewModel.productId, title: product.title, variant_title: product.variants?[0].title, vendor: product.vendor, quantity: 1, name: "", custom: false, price: product.variants?[0].price,properties: [(ProductProperties(image: product.image?.src ?? ""))])
                    print("\n\nold cart : \(CurrentCustomer.currentCartDraftOrder.draft_order.line_items)\n\n")
                    CurrentCustomer.currentCartDraftOrder.draft_order.line_items.append(productToCart)
                    CurrentCustomer.currentCartDraftOrder.draft_order.line_items.removeAll { $0.price == "249.00" }
                    
                    
                    let alert = UIAlertController(title: "Product Added to cart", message: "the product has been added to cart succesfully", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default) { action in
                        print("\n\n current cart : \(CurrentCustomer.currentCartDraftOrder.draft_order.line_items)\n")
                        
                        self.viewModel.updateCartDraftOrder(lineItems: CurrentCustomer.currentCartDraftOrder.draft_order.line_items)
                        print("\n\n\n\nUpdate Draft Order After Put : \(CurrentCustomer.currentCartDraftOrder)\n\n\n\n")
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                }
                
            }else{
                let alert = UIAlertController(title: "Select size/color", message: "You need to select a size/color first", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alert.addAction(ok)
                self.present(alert, animated: true)
                }
                
            
        }else {
            UIAlertController.showGuestAlert(self: self)
        }
    }
    
    @objc func moveToNextIndex(){
        pageCont.moveNextIndex(specificCount: viewModel.product?.product.images?.count ?? 1, specificCollectionView: productCollectionView, pageController: pageController)
    }
    
    @IBAction func addToFavBtnAction(_ sender: Any) {
        if CurrentCustomer.currentCustomer.email != nil {
            
            if !isFavorated { // adding
                
                if let product = viewModel.product?.product{
                    print(product.image?.src)
                    // Get the title of the selected size segment
//                    if let selectedSizeTitle = self.sizeSegmentedController.titleForSegment(at: self.sizeSegmentedController.selectedSegmentIndex) {
//                        favViewModel.productSize = selectedSizeTitle
//                    }
//
//                    // Get the title of the selected color segment
//                    if let selectedColorTitle = self.colorsSegmented.titleForSegment(at: self.colorsSegmented.selectedSegmentIndex) {
//                        favViewModel.productColor = selectedColorTitle
//                    }

                    let productToFav = LineItem(id: 7482947, variant_id: product.variants?[0].id, product_id: viewModel.productId, title: product.title, variant_title: product.variants?[0].title, vendor: product.vendor, quantity: 1, name: "", custom: false, price: product.variants?[0].price,properties: [(ProductProperties(image: product.images?[0].src ?? "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"))])
                    print("\n\nold cart : \(CurrentCustomer.currentFavDraftOrder.draft_order.line_items)\n\n")
                    CurrentCustomer.currentFavDraftOrder.draft_order.line_items.append(productToFav)
                    CurrentCustomer.currentFavDraftOrder.draft_order.line_items.removeAll { $0.price == "294.00" }
                    
                    
                    let alert = UIAlertController(title: "Product Added to Fav", message: "the product has been added to Fav succesfully", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default) { action in
                        self.isFavorated = !self.isFavorated
                        self.setBtnView()
                        print("\n\n current cart : \(CurrentCustomer.currentFavDraftOrder.draft_order.line_items)\n")
                        
                        self.viewModel.updateFavDraftOrder(lineItems: CurrentCustomer.currentFavDraftOrder.draft_order.line_items)
                        print("\n\n\n\nUpdate Draft Order After Put : \(CurrentCustomer.currentFavDraftOrder)\n\n\n\n")
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                }
            }else{
                let alert = UIAlertController(title: "Removing from the wish list", message: "Are you sure you want to delete this product from the wish list?", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Yes", style: .destructive) { action in
                    self.isFavorated = !self.isFavorated
                    self.setBtnView()
                    CurrentCustomer.currentFavDraftOrder.draft_order.line_items.removeAll { $0.title == self.viewModel.product?.product.title }
                    self.viewModel.updateFavDraftOrder(lineItems: CurrentCustomer.currentFavDraftOrder.draft_order.line_items)
                }
                
                let cancle = UIAlertAction(title: "Cancle", style: .cancel)
                alert.addAction(ok)
                alert.addAction(cancle)
            
                self.present(alert, animated: true)

                
            }
            
            
        }else {
            UIAlertController.showGuestAlert(self: self)
        }
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
        
        // Remove all existing segments before adding new ones
        segmentedControl.removeAllSegments()
        
        // Add new segments based on the number of values
        for (index, value) in values.enumerated() {
            segmentedControl.insertSegment(withTitle: value, at: index, animated: false)
        }
        
        // If there are no values, disable the control
        segmentedControl.isEnabled = !values.isEmpty
    }
    
    func setBtnView(){
        if isFavorated{
            addToFavBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else if !isFavorated{
            addToFavBtn.setImage(UIImage(systemName: "heart"), for: .normal)
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

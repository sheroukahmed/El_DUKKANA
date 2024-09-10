//
//  CategoriesViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 06/09/2024.
//

import UIKit
import Kingfisher
import Alamofire
import RxSwift
import RxCocoa


class CategoriesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var FirstSegmentedControl: UISegmentedControl!
    @IBOutlet weak var SecondSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ProductsCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var NoProductsAvailableImage: UIImageView!
    
    var categoriesViewModel: CategoriesViewModelProtocol?
    var dummyImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"
    let disposeBag = DisposeBag()
    var indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        categoriesViewModel = CategoriesViewModel()
        
        categoriesViewModel?.bindToCategoriesViewController = { [weak self] in DispatchQueue.main.async {
            self?.indicator?.stopAnimating()
            guard let self = self else { return }
            self.ProductsCategoriesCollectionView.reloadData()
            self.toggleNoDataView()
        }
        }
        
        
        Observable.combineLatest(
            FirstSegmentedControl.rx.selectedSegmentIndex.map { index -> CollectionID in
                switch index {
                case 1: return .women
                case 2: return .kids
                case 3: return .sale
                default: return .men
                }
            },
            SecondSegmentedControl.rx.selectedSegmentIndex.map { index -> ProductType in
                switch index {
                case 1: return .t_shirt
                case 2: return .accessories
                default: return .shoes
                }
            }
        )
        .subscribe(onNext: { [weak self] collectionId, productType in
            self?.categoriesViewModel?.getProducts(collectionId: collectionId, productType: productType)
        })
        .disposed(by: disposeBag)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesViewModel?.products?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: ProductCell.self), for: indexPath) as! ProductCell
        
            let product = categoriesViewModel?.products?[indexPath.row]
            cell.configureCell(image: product?.image?.src ?? dummyImage, title: product?.title ?? "", price: product?.variants?.first?.price ?? "", currency: "USD", isFavorited: false)
  
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let padding: CGFloat = 5
           let collectionViewWidth = collectionView.frame.width
           let availableWidth = collectionViewWidth - padding * 3
           let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
       }
    
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let storyBoard = UIStoryboard(name: "ProductDetailsStoryboard", bundle: nil)
            if let productDetails = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC {
                
                productDetails.viewModel.productId = self.categoriesViewModel?.products?[indexPath.row].id ?? 1
                
                productDetails.modalPresentationStyle = .fullScreen
                productDetails.modalTransitionStyle = .crossDissolve
                self.present(productDetails, animated: true)
            }
        
            
        } else {
            let alert = UIAlertController(title: "No Internet Connection!", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(ok)
            present(alert, animated: true)
        }
    }
    
    private func setupUI() {
           indicator = UIActivityIndicatorView(style: .large)
           indicator?.center = self.view.center
           indicator?.startAnimating()
           self.view.addSubview(indicator!)

           ProductsCategoriesCollectionView.delegate = self
           ProductsCategoriesCollectionView.dataSource = self
           ProductsCategoriesCollectionView.register(UINib(nibName: String(describing: ProductCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductCell.self))

           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .vertical
           layout.minimumLineSpacing = 5
           layout.minimumInteritemSpacing = 5
           ProductsCategoriesCollectionView.setCollectionViewLayout(layout, animated: true)
       }
    
    private func toggleNoDataView() {
        guard let viewModel = categoriesViewModel else { return }
        let noProducts = categoriesViewModel?.products?.isEmpty ?? true
        if viewModel.isLoading {
            indicator?.startAnimating()
            ProductsCategoriesCollectionView.isHidden = false
            NoProductsAvailableImage.isHidden = true
        } else {
            ProductsCategoriesCollectionView.isHidden = noProducts
            NoProductsAvailableImage.isHidden = !noProducts
        }
    }
  

    @IBAction func goToFavorites(_ sender: Any) {
        
    }
    
    @IBAction func goToCart(_ sender: Any) {
        
    }
    
    @IBAction func goToSearch(_ sender: Any) {
        
    }
}

//
//  HomeViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 05/09/2024.
//

import UIKit

import Kingfisher
import Alamofire

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var searchBar: UINavigationItem!
    @IBOutlet weak var AdsCollectionView: UICollectionView!
    @IBOutlet weak var BrandsCollectionView: UICollectionView!
    
    @IBOutlet weak var Adsimagepanel: UIPageControl!
    var pagecontrol = PageController()
    var adsTimer: Timer?
    var searchViewModel = SearchViewModel()
    var categoriesViewModel = CategoriesViewModel()
    var currentAdIndex = 0
    //sherouk's code
    let Adsimages: [UIImage] = [
        UIImage(named: "cup30")!,
        UIImage(named: "cup40")!,
        UIImage(named: "cup50")!,
        UIImage(named: "Untitled design10")!,
        UIImage(named: "Untitled design111")!
    ]
    let priceRulesForImages: [PriceRules] = [.percent30, .percent40, .percent50, .percent10, .percent25]
        
    
    var homeViewModel: HomeViewModel?

    var dummyBrandImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()


        // MARK: - Ads Collection View SetUp
        AdsCollectionView.delegate = self
        AdsCollectionView.dataSource = self
        AdsCollectionView.register(AdsCollectionViewCell.nib(), forCellWithReuseIdentifier: "CuponsCell")
        
        
        let adsLayout = UICollectionViewCompositionalLayout { [self]sectionIndex,enviroment in
            switch sectionIndex {
            case 0 :
                return self.AdsCollectionStyle()
            default:
                return AdsCollectionStyle()
            }
        }
        AdsCollectionView.setCollectionViewLayout(adsLayout, animated: true)
        Adsimagepanel.numberOfPages = Adsimages.count
    
        adsTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(autoScrollAds), userInfo: nil, repeats: true)

        
        
        // MARK: - Brands Collection View SetUp
        BrandsCollectionView.delegate = self
        BrandsCollectionView.dataSource = self
        BrandsCollectionView.register(BrandsCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BrandsCell")

        
        let brandsLayout = UICollectionViewFlowLayout()
        brandsLayout.scrollDirection = .vertical
        brandsLayout.minimumLineSpacing = 10
        brandsLayout.minimumInteritemSpacing = 10
        
        BrandsCollectionView.setCollectionViewLayout(brandsLayout, animated: true)

        

        homeViewModel = HomeViewModel()
       

        homeViewModel?.getBrands()
        homeViewModel?.bindToHomeViewController = { [weak self] in DispatchQueue.main.async {
            guard let self = self else { return }
            self.BrandsCollectionView.reloadData()
        }
        }
        
    }
    
    
    
    
    // MARK: - Collection View Data Source Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == AdsCollectionView {
            return 5
        } else if collectionView == BrandsCollectionView {
            return homeViewModel?.brands?.count ?? 0
        }
        return 0
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == AdsCollectionView {
            let cell = AdsCollectionView.dequeueReusableCell(withReuseIdentifier: "CuponsCell", for: indexPath) as! AdsCollectionViewCell
            cell.cuponImage.image = Adsimages[indexPath.row]
            Adsimagepanel.currentPage = indexPath.row
            return cell
        } else if collectionView == BrandsCollectionView {
            let brandCell = BrandsCollectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCell", for: indexPath) as! BrandsCollectionViewCell

            brandCell.brandImage.kf.setImage(with: URL(string: homeViewModel?.brands?[indexPath.row].image?.src ?? dummyBrandImage))
            print(homeViewModel?.brands?[indexPath.row].image?.src ?? "No Image URL")

            brandCell.layer.cornerRadius = 30

  
            return brandCell
        }
        return UICollectionViewCell()

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == AdsCollectionView {
                let selectedPriceRule = priceRulesForImages[indexPath.row]
                homeViewModel?.selectedpricerule = selectedPriceRule.rawValue
     
                homeViewModel?.getDiscount()
                homeViewModel?.discountCodeUpdated = { [weak self] in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        UIPasteboard.general.string = self.homeViewModel?.discountCode
                        let alert = UIAlertController(title: "Copied!", message: "Discount code has been copied to clipboard.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
     
                }
                print(homeViewModel?.discountCode ?? "ooooooooooo")
                UIPasteboard.general.string = homeViewModel?.discountCode
                
                
                let alert = UIAlertController(title: "Copied!", message: "Text has been copied to clipboard.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
        
        
            }else{
                if collectionView == BrandsCollectionView {
                    if NetworkReachabilityManager()?.isReachable ?? false {
                        if let brandProducts = self.storyboard?.instantiateViewController(withIdentifier: "brandProducts") as? BrandViewController {
                            brandProducts.hidden = true
                            brandProducts.brandViewModel = BrandViewModel(brand: homeViewModel?.brands?[indexPath.row].title ?? "")
                            brandProducts.title = homeViewModel?.brands?[indexPath.row].title
                            
                            self.navigationController?.pushViewController(brandProducts, animated: true)
                        }} else {
                        let alert = UIAlertController(title: "No Internet Connection!", message: "Please check your internet connection and try again.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .cancel)
                        alert.addAction(ok)
                        present(alert, animated: true)
                    }
                }
                
            }
        }
    
    // MARK: - Ads Collection View Layout Detailes
    
    @objc func autoScrollAds() {
        pagecontrol.moveNextIndex(specificCount:Adsimages.count ,specificCollectionView:AdsCollectionView, pageController: Adsimagepanel)
        }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == AdsCollectionView {
            
            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            currentAdIndex = pageIndex
            
            Adsimagepanel.currentPage = currentAdIndex
        }
    }

    
    func AdsCollectionStyle()-> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(292), heightDimension: .absolute(119))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            

            section.visibleItemsInvalidationHandler = { (items, offset, environment) in
                items.forEach { item in
                    let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                    let minScale: CGFloat = 0.8
                    let maxScale: CGFloat = 1.0
                    let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                    item.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
            return section
        }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == BrandsCollectionView {
            let padding: CGFloat = 10
            let collectionViewWidth = collectionView.frame.width
            let availableWidth = collectionViewWidth - padding * 3
            let widthPerItem = availableWidth / 2
            return CGSize(width: widthPerItem, height: widthPerItem)
            
        }
          return CGSize()
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           if collectionView == BrandsCollectionView {
               return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
           }
           return UIEdgeInsets()
       }

    private func setupUI() {
        let customColor = UIColor(red: 0.403, green: 0.075, blue: 0.067, alpha: 1.0)
        
        self.navigationController?.navigationBar.tintColor = customColor

        // Create search button (left side)
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(searchButtonTapped))
        searchButton.tintColor = customColor
        
        // Create cart button (right side)
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(cartButtonTapped))
        cartButton.tintColor = customColor

        // Create favorite button (right side)
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(favoriteButtonTapped))
        favoriteButton.tintColor = customColor

        // Set left bar button (Search)
        navigationItem.leftBarButtonItem = searchButton
        
        // Set right bar buttons (Cart and Favorite)
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
         spacer.width = 1
         navigationItem.rightBarButtonItems = [favoriteButton, spacer, cartButton]
        
    }
    

    
    @objc func searchButtonTapped() {
        let products = self.storyboard?.instantiateViewController(withIdentifier: "brandProducts") as! BrandViewController

        products.hidden = false
        self.navigationController?.pushViewController(products, animated: true)

    }

    @objc func cartButtonTapped() {
        print("Cart button tapped")
    }

    @objc func favoriteButtonTapped() {
        print("Favorite button tapped")
    }
   

    
}

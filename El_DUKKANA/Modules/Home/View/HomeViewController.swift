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
    
    @IBOutlet weak var AdsCollectionView: UICollectionView!
    @IBOutlet weak var BrandsCollectionView: UICollectionView!
    
    @IBOutlet weak var Adsimagepanel: UIPageControl!
    var adsTimer: Timer?
    var currentAdIndex = 0
    //sherouk's code
    let Adsimages: [UIImage] = [
        UIImage(named: "cup30")!,
        UIImage(named: "cup40")!,
        UIImage(named: "cup50")!,
        UIImage(named: "Untitled design10")!,
        UIImage(named: "Untitled design111")!
    ]
    
    var homeViewModel: HomeViewModelProtocol?

    var dummyBrandImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"


    //var dummyBrandImage = UIImage(named: "EL DUKKANA")

    


    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    // MARK: - Ads Collection View Layout Detailes
    
    @objc func autoScrollAds() {
            if currentAdIndex < Adsimagepanel.numberOfPages - 1 {
                currentAdIndex += 1
            } else {
                currentAdIndex = 0
            }
            
            let indexPath = IndexPath(item: currentAdIndex, section: 0)
            AdsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            Adsimagepanel.currentPage = currentAdIndex
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

    
    @IBAction func goToFavorites(_ sender: Any) {
        
    }
    
    @IBAction func goToCart(_ sender: Any) {
        
    }
    
    @IBAction func goToSearch(_ sender: Any) {
        
    }
    
}

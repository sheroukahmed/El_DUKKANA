//
//  ReviewsViewController.swift
//  El_DUKKANA
//
//  Created by ios on 07/09/2024.
//

import UIKit

class ReviewsViewController: UIViewController, AddNewReviewProtocol {

    var viewModel = ReviewsViewModel()
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var productNameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        reviewCollectionView.dataSource = self
        reviewCollectionView.delegate = self
        
            
        
    }
    
    func didAddReview(_ review: Reviews) {
            viewModel.reviews.append(review)
            // Reload the collection view to display the new review
            reviewCollectionView.reloadData()
        }
    
    @IBAction func addReviewBtn(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddReviewVC") as? AddReviewVC {
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
extension ReviewsViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.reviews.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = reviewCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReviewCell
        let arrOfData = viewModel.reviews[indexPath.row]
        cell.reviewTitle.text = arrOfData.reviewTitle
        cell.reviewBodyTxt.text = arrOfData.reviewBody
        cell.reviewerImage.image = arrOfData.reviewrImage
        //cell.reviewerImage.layer.cornerRadius = cell.reviewerImage.frame.width / 2
        cell.reviewerNameLbl.text = arrOfData.reviewrName
        cell.reviewingDate.text = arrOfData.reviewingDate
        
        let starImageViews = [cell.star1Img, cell.star2Img, cell.star3Img, cell.star4Img, cell.star5Img]
        let fullStar = UIImage(systemName: "star.fill")
        let emptyStar = UIImage(systemName: "star")
        let halfStar = UIImage(systemName: "star.leadinghalf.filled")
        let rating = arrOfData.reviewStars
        
        for (index, starImageView) in starImageViews.enumerated() {
            if Double(index) < rating {
                if (rating ) - Double(index) >= 1 {
                        starImageView?.image = fullStar
                    } else {
                        starImageView?.image = halfStar
                    }
                } else {
                    starImageView?.image = emptyStar 
                }
            }
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let alert = UIAlertController(title: "Delete Review", message: "Are you sure you want to delete this review?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                guard let self = self else { return }

                let reviewToDelete = self.viewModel.reviews[indexPath.row]
                self.viewModel.deleteReview(reviewToDelete)
                
                self.reviewCollectionView.performBatchUpdates({
                    self.reviewCollectionView.deleteItems(at: [indexPath])
                }, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    
}

//
//  AddReviewVC.swift
//  El_DUKKANA
//
//  Created by ios on 07/09/2024.
//

import UIKit
import RxSwift
import RxCocoa

class AddReviewVC: UIViewController {

    var viewModel: ReviewsViewModel?
    var delegate : AddNewReviewProtocol?
    private let disposeBag = DisposeBag()
    private let starRating = BehaviorRelay<Int>(value: 0)
    @IBOutlet weak var star5Btn: UIButton!
    @IBOutlet weak var star4Btn: UIButton!
    @IBOutlet weak var star3Btn: UIButton!
    @IBOutlet weak var star2Btn: UIButton!
    @IBOutlet weak var star1Btn: UIButton!
    @IBOutlet weak var addReviewBtn: UIButton!{
        didSet{
            ViewsSet.btnSet(btn: addReviewBtn)
        }
    }
    @IBOutlet weak var reviewBodyTF: UITextView!
    @IBOutlet weak var reviewTitleTF: UITextField!
    @IBOutlet weak var reviewerNameTF: UITextField!
    @IBOutlet weak var reviewerImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        print(CurrentCustomer.currentCustomer)
        
        viewModel = ReviewsViewModel()
        
        bindStarButtons()
        
        starRating.asObservable()
                    .subscribe(onNext: { [weak self] rating in
                        self?.updateStarImages(rating: rating)
                    })
                    .disposed(by: disposeBag)
    }
    
    @IBAction func addReviewBtn(_ sender: Any) {
        
        if reviewTitleTF.text == "" || reviewerNameTF.text == "" {
            let alert = UIAlertController(title: "Missing Informations!", message: "Add a Title/Name and try again", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
        let newReview = Reviews(reviewTitle: reviewTitleTF.text ?? "",
                                 reviewBody: reviewBodyTF.text ?? "",
                                 reviewrImage: reviewerImg.image ?? UIImage(systemName: "person.circle")!,
                                 reviewrName: reviewerNameTF.text ?? "",
                                 reviewingDate: "2024/9/7",
                                 reviewStars: Double(starRating.value))
        
        CoreDataManager.shared.addReview(reviewTitle: newReview.reviewTitle,
                                              reviewBody: newReview.reviewBody,
                                              reviewrImage: newReview.reviewrImage,
                                              reviewrName: newReview.reviewrName,
                                              reviewingDate: newReview.reviewingDate,
                                         reviewStars: Int16(newReview.reviewStars))
        viewModel?.reviews.append(newReview)
        delegate?.didAddReview(newReview)
        self.dismiss(animated: true)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func bindStarButtons() {
            // Bind each button tap to update the starRating value
            star1Btn.rx.tap
                .map { 1 }
                .bind(to: starRating)
                .disposed(by: disposeBag)

            star2Btn.rx.tap
                .map { 2 }
                .bind(to: starRating)
                .disposed(by: disposeBag)

            star3Btn.rx.tap
                .map { 3 }
                .bind(to: starRating)
                .disposed(by: disposeBag)

            star4Btn.rx.tap
                .map { 4 }
                .bind(to: starRating)
                .disposed(by: disposeBag)

            star5Btn.rx.tap
                .map { 5 }
                .bind(to: starRating)
                .disposed(by: disposeBag)
        }

        private func updateStarImages(rating: Int) {
            // Set the star images based on the rating
            let filledStarImage = UIImage(systemName: "star.fill")
            let emptyStarImage = UIImage(systemName: "star")

            star1Btn.setImage(rating >= 1 ? filledStarImage : emptyStarImage, for: .normal)
            star2Btn.setImage(rating >= 2 ? filledStarImage : emptyStarImage, for: .normal)
            star3Btn.setImage(rating >= 3 ? filledStarImage : emptyStarImage, for: .normal)
            star4Btn.setImage(rating >= 4 ? filledStarImage : emptyStarImage, for: .normal)
            star5Btn.setImage(rating >= 5 ? filledStarImage : emptyStarImage, for: .normal)
        }

}

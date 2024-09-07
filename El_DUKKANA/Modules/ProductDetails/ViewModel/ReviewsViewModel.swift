//
//  ReviewsViewModel.swift
//  El_DUKKANA
//
//  Created by ios on 06/09/2024.
//

import Foundation
import UIKit

class ReviewsViewModel{
    
    var reviews = [Reviews]()
        
        init() {
            loadReviews()
        }
    
    func loadReviews() {
            let coreDataReviews = CoreDataManager.shared.fetchReviews()
            self.reviews = coreDataReviews.map { reviewEntity in
                Reviews(
                    reviewTitle: reviewEntity.reviewTitle ?? "",
                    reviewBody: reviewEntity.reviewBody ?? "",
                    reviewrImage: UIImage(data: reviewEntity.reviewrImage ?? Data()) ?? UIImage(systemName: "person.circle")!,
                    reviewrName: reviewEntity.reviewrName ?? "",
                    reviewingDate: reviewEntity.reviewingDate ?? "",
                    reviewStars: Double(Int(reviewEntity.reviewStars))
                )
            }
        }
    
    func addReview(reviewTitle: String, reviewBody: String, reviewrImage: UIImage, reviewrName: String, reviewingDate: String, reviewStars: Int) {
            CoreDataManager.shared.addReview(
                reviewTitle: reviewTitle,
                reviewBody: reviewBody,
                reviewrImage: reviewrImage,
                reviewrName: reviewrName,
                reviewingDate: reviewingDate,
                reviewStars: Int16(reviewStars)
            )
            loadReviews() // Reload the reviews after adding a new one
        }
    
    func deleteReview(_ review: Reviews) {
            guard let reviewEntity = CoreDataManager.shared.fetchReviews().first(where: { $0.reviewTitle == review.reviewTitle }) else { return }
            CoreDataManager.shared.deleteReview(reviewEntity)
            loadReviews() // Reload reviews after deletion
        }
    
    func getRandomReviews() -> [Reviews] {
            return reviews.shuffled().prefix(3).map { $0 }
        }
}

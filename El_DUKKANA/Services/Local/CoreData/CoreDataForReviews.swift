//
//  CoreDataForReviews.swift
//  El_DUKKANA
//
//  Created by ios on 07/09/2024.
//

import CoreData
import UIKit

class CoreDataManager {
    // Singleton
    static let shared = CoreDataManager()
    

    private let persistentContainer: NSPersistentContainer
    
  
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "El_DUKKANA")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
    }

    
    // Save context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    // Fetch all reviews
    func fetchReviews() -> [ReviewEntity] {
        let fetchRequest: NSFetchRequest<ReviewEntity> = ReviewEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch reviews: \(error)")
            return []
        }
    }
    
    // Add a new review
    func addReview(reviewTitle: String, reviewBody: String, reviewrImage: UIImage, reviewrName: String, reviewingDate: String, reviewStars: Int16) {
        let newReview = ReviewEntity(context: context)
        newReview.reviewTitle = reviewTitle
        newReview.reviewBody = reviewBody
        newReview.reviewrImage = reviewrImage.pngData()
        newReview.reviewrName = reviewrName
        newReview.reviewingDate = reviewingDate
        newReview.reviewStars = reviewStars
        saveContext()
    }
    
    // Delete a review
        func deleteReview(_ review: ReviewEntity) {
            context.delete(review)
            saveContext()
        }
    
    
}

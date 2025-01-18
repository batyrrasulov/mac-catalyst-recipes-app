/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A structure that provides a reusable delete recipe confirmation alert controller.
*/

import UIKit

struct Alert {
    
    static func confirmDelete(of recipe: Recipe, completion: ((Bool) -> Void)?) -> UIAlertController {
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            let didDelete = dataStore.delete(recipe)
            if let completion = completion {
                completion(didDelete)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            if let completion = completion {
                completion(false)
            }
        }
        
        let alert = UIAlertController(
            title: "Are you sure you want to delete \(recipe.title)?",
            message: nil,
            preferredStyle: .actionSheet)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
}

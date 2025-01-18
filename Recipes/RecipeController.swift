/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An interface that determines whether the responder can receive a recipe.
*/

import Foundation

protocol RecipeController {
 
    var recipe: Recipe? { get set }
    
}

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The recipe list view controller.
*/

import UIKit
import Combine

class RecipeListViewController: UIViewController {

    static let storyboardID = "RecipeList"
    static func instantiateFromStoryboard() -> RecipeListViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(identifier: storyboardID) as? RecipeListViewController
    }

    @IBOutlet weak var collectionView: UICollectionView!

    enum Section: Int {
        case main
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, Recipe>!

    private var recipeCollectionName: String?
    private var selectedDataType: TabBarItem = .all
    private var selectedRecipe: Recipe?
    
    private var dataStoreSubscriber: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBarController = self.tabBarController,
           let dataType = TabBarItem(rawValue: tabBarController.selectedIndex) {
            selectedDataType = dataType
        }

        configureCollectionView()
        configureDataSource()
        
        // Listen for recipe changes in the data store.
        dataStoreSubscriber = dataStore.$allRecipes
            .receive(on: RunLoop.main)
            .sink { [weak self] recipes in
                guard let self = self else { return }
                self.apply(recipes, animated: false)
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController else { return }
        
        // Prevent the user from dismissing the recipe editor by swiping down.
        if let recipeEditor = navController.topViewController as? RecipeEditorViewController {
            recipeEditor.isModalInPresentation = true
        }
    }
    
}

extension RecipeListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = dataSource.itemIdentifier(for: indexPath)
        if recipe == self.selectedRecipe {
            return
        }
        self.selectedRecipe = recipe
        
        guard let recipeDetailViewController = RecipeDetailViewController.instantiateFromStoryboard() else { return }
        recipeDetailViewController.recipe = recipe
        let navigationController = UINavigationController(rootViewController: recipeDetailViewController)
        showDetailViewController(navigationController, sender: self)
    }

}

extension RecipeListViewController {
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = createCollectionViewLayout()
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let recipeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let recipeItem = NSCollectionLayoutItem(layoutSize: recipeItemSize)
        recipeItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 10.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.375))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: recipeItem, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}

extension RecipeListViewController {
    
    func configureDataSource() {
        // Register the cell that displays a recipe in the collection view.
        collectionView.register(RecipeListCell.nib, forCellWithReuseIdentifier: RecipeListCell.reuseIdentifier)

        // Create a diffable data source, and configure the cell with recipe data.
        dataSource = UICollectionViewDiffableDataSource <Section, Recipe>(collectionView: self.collectionView) { (
            collectionView: UICollectionView,
            indexPath: IndexPath,
            recipe: Recipe) -> UICollectionViewCell? in
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeListCell.reuseIdentifier, for: indexPath)
            
            if let recipeListCell = cell as? RecipeListCell {
                recipeListCell.configure(with: recipe)
            }
        
            return cell
        }
    }
    
    func apply(_ recipes: [Recipe], animated: Bool) {
        // Determine what recipes to append to the snapshot.
        let recipesToAppend: [Recipe]
        switch selectedDataType {
        case .favorites:
            recipesToAppend = recipes.filter { $0.isFavorite }
        case .recents:
            let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
            recipesToAppend = recipes.filter { $0.addedOnDate > thirtyDaysAgo }
        case .collections:
            if let collectionName = self.recipeCollectionName {
                let recipeCollection = recipes.filter { $0.collections.contains(collectionName) }
                recipesToAppend = recipeCollection
            } else {
                recipesToAppend = recipes
            }
        default:
            recipesToAppend = recipes
        }

        // Append the recipes to a snapshot.
        var snapshot = NSDiffableDataSourceSnapshot<Section, Recipe>()
        snapshot.appendSections([.main])
        snapshot.appendItems(recipesToAppend)

        // Get the index path to the selected recipe, if there is one.
        var selectedRecipeIndexPath: IndexPath? = nil
        if let selectedRecipe = self.selectedRecipe {
            if let itemIndex = recipesToAppend.firstIndex(of: selectedRecipe) {
                selectedRecipeIndexPath = IndexPath(item: itemIndex, section: Section.main.rawValue)
            }
        }

        dataSource.apply(snapshot, animatingDifferences: animated) { [weak self] in
            guard
                let self = self,
                let indexPath = selectedRecipeIndexPath
            else { return }
            // Reselect the recipe if previously selected.
            self.collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: [])
        }
    }

}

extension RecipeListViewController {
    
    func showRecipes(_ tabBarItem: TabBarItem) {
        selectedDataType = tabBarItem
        apply(dataStore.allRecipes, animated: true)
    }
    
    func showRecipes(from collection: String) {
        selectedDataType = .collections
        recipeCollectionName = collection
        apply(dataStore.allRecipes, animated: true)
    }

}

// MARK: - Unwind Segues
extension RecipeListViewController {
    
    @IBAction func cancelRecipeEditor(_ unwindSegue: UIStoryboardSegue) {
        // Do nothing.
    }
    
    @IBAction func saveRecipeEditor(_ unwindSegue: UIStoryboardSegue) {
        guard
            let recipeEditor = unwindSegue.source as? RecipeEditorViewController,
            let recipe = recipeEditor.editedRecipe()
        else { return }

        let recipeToSelect = dataStore.add(recipe)

        if UIDevice.current.userInterfaceIdiom == .pad {
            if let indexPath = dataSource.indexPath(for: recipeToSelect) {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
                self.collectionView(collectionView, didSelectItemAt: indexPath)
            }
        }
    }

}

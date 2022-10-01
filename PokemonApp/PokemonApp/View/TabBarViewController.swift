//
//  TabBarViewController.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/29.
//

import UIKit

private enum Tab {

    case home
    
    case favorite
    
    func controller() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
            
        case .home: controller = UINavigationController(rootViewController: HomeViewController())
            
        case .favorite: controller = UINavigationController(rootViewController: FavoriteViewController())
            
        }
        
        controller.tabBarItem = tabBarItem()
        
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
        
        return controller
    }
    
    func tabBarItem() -> UITabBarItem {
        
        switch self {

        case .home:
            return UITabBarItem(
                title: "Home",
                image: .systemAsset(.house),
                selectedImage: .systemAsset(.houseFill)
            )
            
        case .favorite:
            return UITabBarItem(
                title: "Favorite",
                image: .systemAsset(.star),
                selectedImage: .systemAsset(.starFill)
            )
        }
    }
}

class TabBarViewController: UITabBarController {
    
    private let tabs: [Tab] = [.home, .favorite]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = tabs.map({ $0.controller() })
        
        view.backgroundColor = .white
        
        let tabBarAppearance =  UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.stackedLayoutAppearance.normal.badgeBackgroundColor = .orange
        tabBar.tintColor = .black
        tabBar.scrollEdgeAppearance = tabBarAppearance
        tabBar.standardAppearance = tabBarAppearance
        
        let navBarAppearance =  UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(red: 181/255, green: 8/255, blue: 8/255, alpha: 100)
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                .font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateBadge),
                                               name: .didChangeFavorite,
                                               object: nil)
        
        updateBadge()
    }
    
    @objc private func updateBadge() {
        
        StorageManager.shared.fetchPokemons { result in
            
            switch result {
                
            case .success(let lsPokemons):
                
                let badgeCount = lsPokemons.count
                
                DispatchQueue.main.async {
                    
                    if badgeCount > 0 {
                        
                        self.tabBar.items?[1].badgeValue = "\(lsPokemons.count)"
                    } else {
                        
                        self.tabBar.items?[1].badgeValue = nil
                    }
                }
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
}


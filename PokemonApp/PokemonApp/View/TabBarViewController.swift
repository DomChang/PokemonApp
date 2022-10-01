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
        tabBar.scrollEdgeAppearance = tabBarAppearance
        tabBar.standardAppearance = tabBarAppearance
        
        let navBarAppearance =  UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
    }
}


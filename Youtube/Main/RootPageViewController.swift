//
//  RootPageViewController.swift
//  Youtube
//
//  Created by marco rodriguez on 30/06/22.
//

import UIKit

class RootPageViewController: UIPageViewController {

    //El total de VC que voy a tener
    var subViewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Al usar este componente necesito 2 delegados
        delegate = self
        dataSource = self
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        subViewControllers = [
        HomeViewController(),
        VideosViewController(),
        PlaylistsViewController(),
        ChannelViewController(),
        AboutViewController()
        ]
        
        //Cual es el controlador por defecto que va aparecer
        setViewControllerFromIndex(index: 0, direction: .forward)
        
    }
    
    //Este metodo se puede mandar llamar desde otro sitio
    func setViewControllerFromIndex(index: Int, direction: NavigationDirection, animated: Bool = true) {
        setViewControllers([subViewControllers[index]], direction: direction, animated: animated)
    }
    
}


//Saber cual es el listado de VC
extension RootPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index : Int = subViewControllers.firstIndex(of: viewController) ?? 0
        //leer el subVC y retornarlo
        //Validar que sea el primero
        if index <= 0 {
            return nil
        }
        return subViewControllers[index-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index : Int = subViewControllers.firstIndex(of: viewController) ?? 0
        //leer el subVC y retornarlo
        //Validar que sea el ultimo
        if index >= (subViewControllers.count-1) {
            return nil
        }
        return subViewControllers[index+1]
    }
    
    //Cuantas pantallas voy a presentar
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
}

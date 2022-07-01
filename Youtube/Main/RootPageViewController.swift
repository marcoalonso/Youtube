//
//  RootPageViewController.swift
//  Youtube
//
//  Created by marco rodriguez on 30/06/22.
// https://www.youtube.com/watch?v=63v0hOo-cbI&list=PLT_OObKZ3CpuEomHCc6v-49u3DFCdCyLH&index=8

import UIKit

//Patron delegation
protocol RootPageProtocol : AnyObject {
    func currentPage(_ index: Int)
}

class RootPageViewController: UIPageViewController {

    //El total de VC que voy a tener
    var subViewControllers = [UIViewController]()
    var currentIndex: Int = 0
    
    //desde afuera alguien pueda suscribirse para que desde aqui se puedan mandar llamar metodos
    weak var delegateRoot : RootPageProtocol?
    
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
        
        // Etiquetar cada vc
        _ = subViewControllers.enumerated().map({$0.element.view.tag = $0.offset})
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
    
    //Saber cuando termina la animacion
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("DEBUG: Fnished : \(finished)")
        if let index = pageViewController.viewControllers?.first?.view.tag {
            print(index)
            currentIndex = index
            delegateRoot?.currentPage(index)
        }
    }
    
}

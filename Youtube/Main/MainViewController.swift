//
//  MainViewController.swift
//  Youtube
//
//  Created by marco rodriguez on 30/06/22.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var tabsView: TabsView!
    //Crear una instancia del page
    var rootPageViewController: RootPageViewController!
    
    private var options: [String] = [ "HOME", "VIDEOS" , "PLAYLIST", "CHANNEL" , "ABOUT"]

    override func viewDidLoad() {
        super.viewDidLoad()
        //se manda llamar de la clase que hereda
        configNavigationBar()
        //tabsView.buildView(delegate: self, options: options)
        //ocultar bar al hacer scroll, el problema es que no aparece de nuevo, para resolver eso lo haremos en el HomeVc con el método scrollViewDidScroll
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RootPageViewController {
            destination.delegateRoot = self
            rootPageViewController = destination
            
        }
    }
    
    override func dotsButtonPressed() {
        configButtonSheet()
    }
    
    override func magnifyButtonPressed() {
        print("Botton magnifyButtonPressed desde MainVc")
    }
    
    func configButtonSheet(){
        //crear vc
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }

}
extension MainViewController: RootPageProtocol {
    func currentPage(_ index: Int) {
        print("currentPage: ", index)
    }
    
    
}


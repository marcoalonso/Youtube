//
//  BaseViewController.swift
//  Youtube
//
//  Created by marco rodriguez on 13/07/22.
//

import UIKit
enum LoadingViewState {
    case show
    case hide
}

protocol BaseViewProtocol {
    func loadingView(_ state: LoadingViewState)
    func showError(_ error: String, callback: (()->Void)?)
}


class BaseViewController: UIViewController {

    var loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func configNavigationBar(){
        //stack con 3 botones de arriba
        let stackOptions = UIStackView()
        stackOptions.axis = .horizontal
        stackOptions.distribution = .fillEqually
        stackOptions.spacing = 0.0
        stackOptions.translatesAutoresizingMaskIntoConstraints = false
        
        //Crear los botones
        let share = buildButtons(selector: #selector(shareButtonPressed), image: .castImage, inset: 30)
        let magnify = buildButtons(selector: #selector(magnifyButtonPressed), image: .magnifyingImage, inset: 30)
        let dots = buildButtons(selector: #selector(dotsButtonPressed), image: .dotsImage, inset: 30)
        
        //agregar los botones al stack
        stackOptions.addArrangedSubview(share)
        stackOptions.addArrangedSubview(magnify)
        stackOptions.addArrangedSubview(dots)
        
        //Ancho del stack de 120
        stackOptions.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //el elemento nativo del custom bar tendrá un customView
        let customItemView = UIBarButtonItem(customView: stackOptions)
        customItemView.tintColor = .clear
        navigationItem.rightBarButtonItem = customItemView
    }
    
    //este metodo va a construir los botones con los parametros que recibe y devuelva la instancia de un boton
    private func buildButtons(selector : Selector, image : UIImage, inset : CGFloat) -> UIButton{
        let button = UIButton(type: .custom)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.tintColor = .whiteColor
        let extraPadding : CGFloat = 2.0
        button.imageEdgeInsets = UIEdgeInsets(top: inset+extraPadding, left: inset, bottom: inset+extraPadding, right: inset)
        return button
    }
    
    @objc func shareButtonPressed(){
        print("shareButtonPressed")
    }
    
    @objc func magnifyButtonPressed(){
        print("magnifyButtonPressed")
    }
    
    @objc func dotsButtonPressed(){
        print("dotsButtonPressed")
    }

}

extension BaseViewController {
    func showError(_ error: String, callback: (()->Void)?){
        //reintentar el llamado al API
        let alerta = UIAlertController(title: "ERROR", message: error, preferredStyle: .alert)
        if let callback = callback {
            alerta.addAction(UIAlertAction(title: "Intentar de nuevo", style: .default, handler: { action in
                if action.style == .default {
                    callback()
                }
            }))
        }
        alerta.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
            if action.style == .cancel {
                print("Ok ")
            }
        }))
       
        present(alerta, animated: true)
    }
    
    func loadingView(_ state: LoadingViewState) {
        switch state {
        case .show:
            showLoading()
        case .hide:
            hideLoading()
        }
    }
    
    private func showLoading() {
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
    }
    
    private func hideLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
}

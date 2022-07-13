//
//  HomeViewController.swift
//  Youtube
//
//  Created by marco rodriguez on 30/06/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableViewHome: UITableView!
    
    //crear una instancia, conectar la capa del VC con el presenter
    lazy var presenter = HomePresenter(delegate: self) //se pasará la instancia lazy
    
    private var objectList: [[Any]] = []
    private var sectionTitleList: [String] = [] //se puede utilizar el mismo atributo que esta dentro del presenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()

        //Este closure manda llamar algo que se ejecuta en 2 plano
        Task {
            //Toma la instancia del presenter y manda llamar al metodo
            await presenter.getHomeObjects()
        }
    }
    
    func configTableView(){
        tableViewHome.register(cell: ChannelCell.self)
        tableViewHome.register(cell: VideoCell.self)
        tableViewHome.register(cell: PlaylistCell.self)
        tableViewHome.registerFromClass(headerFooterView: SectionTitleView.self)
        
        tableViewHome.delegate = self
        tableViewHome.dataSource = self
        tableViewHome.separatorColor = .clear
        tableViewHome.contentInset = UIEdgeInsets(top: -15, left: 0, bottom: -80, right: 0)
    }

    //Ocultar y mostrar el Navigation Bar ⇧
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //se agrega una gestura
        let pan = scrollView.panGestureRecognizer
        //se identica la velocidad para mostrar u ocultar
        let velocity = pan.velocity(in: scrollView).y
        velocity < -25 ? navigationController?.setNavigationBarHidden(true, animated: true) : navigationController?.setNavigationBarHidden(false, animated: true)

    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectList[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = objectList[indexPath.section]
        
        if let channel = item as? [ChannelModel.Items] {
            let channelCell = tableView.dequeueReusableCell(for: ChannelCell.self, for: indexPath)
            channelCell.configCell(model: channel[indexPath.row])
            return channelCell
            
        } else if let playlistItems = item as? [PlaylistItemsModel.Item] {
            let playlistItemsCell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
            
            playlistItemsCell.configCell(model: playlistItems[indexPath.row])
            //Implemento el closure lo que suceda en la celda
            playlistItemsCell.didTapDotsButton = { [weak self] in
                self?.configButtonSheet()
            }
            return playlistItemsCell
            
        } else if let videos = item as? [VideoModel.Item] {
            let videoCell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
            //Implemento el closure lo que suceda en la celda
            videoCell.didTapDotsButton = { [weak self] in
                self?.configButtonSheet()
            }
            videoCell.configCell(model: videos[indexPath.row])
            return videoCell
            
        } else if let playlist = item as? [PlaylistModel.Item] {
            let playlistCell = tableView.dequeueReusableCell(for: PlaylistCell.self, for: indexPath)
            
            playlistCell.configCell(model: playlist[indexPath.row])
            //Implemento el closure lo que suceda en la celda
            playlistCell.didTapDotsButton = { [weak self] in
                self?.configButtonSheet()
            }
            return playlistCell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 || indexPath.section == 2 {
            return 95.0
        }
        return UITableView.automaticDimension
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return sectionTitleList[section]
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "\(SectionTitleView.self)") as? SectionTitleView else {
            return nil
        }
        sectionView.title.text = sectionTitleList[section]
        sectionView.configView()
        return sectionView
    }
    
    func configButtonSheet(){
        //crear vc
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
}

extension HomeViewController: HomeViewProtocol {
    func getData(list: [[Any]], sectionTitleList: [String]) {
        objectList = list
        self.sectionTitleList = sectionTitleList
        tableViewHome.reloadData()
    }
    
    
}

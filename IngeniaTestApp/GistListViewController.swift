//
//  GistListViewController.swift
//  IngeniaTestApp
//
//  Created by Israel Gutiérrez on 25/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit
import CoreData

class GistListViewController: UITableViewController {
    
    var searchController: UISearchController! = nil
    var leftButtonItemView: UIBarButtonItem! = nil
    
    //
    private var arrayOfElements: Array<GistCD>! = Array<GistCD>()
    private var filteredElements: Array<GistCD>! = Array<GistCD>()
    private var companyView: UIImageView! = nil
    weak private var timer: Timer! = nil
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    init(style: UITableViewStyle, newArrayOfElements: Array<GistCD>) {
        
        super.init(style: style)
        
        arrayOfElements = newArrayOfElements
        filteredElements = newArrayOfElements
        
        self.initInterface()
        
    }
    
    override init(style: UITableViewStyle) {
        
        super.init(style: style)
        
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.initInterface()
        
    }
    
    private func initInterface() {
        
        self.title = "Gists"
        
        self.getInfoFromServer()
        self.initBehavior()
        self.editNavigationController()
        self.initTableView()
        self.initSearchController()
        
    }
    
    private func initBehavior() {
        
        timer = Timer.scheduledTimer(timeInterval: 60.0 * 15.0, target: self, selector: #selector(getInfoFromServer), userInfo: nil, repeats: true)
        
    }
    
    private func editNavigationController() {
        
        self.changeBackButtonItem()
        self.changeNavigationBarTitle()
        
    }
    
    private func changeBackButtonItem() {
        
        let leftButton = UIBarButtonItem(title: "",
                                         style: UIBarButtonItemStyle.plain,
                                         target: nil,
                                         action: nil)
        
        self.navigationItem.leftBarButtonItem = leftButton
        
    }
    
    private func changeNavigationBarTitle() {
        
        let titleLabel = UILabel.init(frame: CGRect.zero)
        
        let font = UIFont.init(name: "AppleSDGothicNeo-Light",
                               size: 18.0 * UtilityManager.sharedInstance.conversionWidth)
        let color = UIColor.black
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let stringWithFormat = NSMutableAttributedString(
            string: "Gists",
            attributes:[NSFontAttributeName:font!,
                        NSParagraphStyleAttributeName:style,
                        NSForegroundColorAttributeName:color
            ]
        )
        titleLabel.attributedText = stringWithFormat
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
    }
    
    private func initTableView() {
        
        self.tableView.register(GistCustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.refreshControl = UIRefreshControl.init()
        self.refreshControl?.backgroundColor = UIColor.gray
        self.refreshControl?.addTarget(self, action: #selector(getInfoFromServer), for: .valueChanged)
        
    }
    
    private func initSearchController() {
        
        searchController = UISearchController.init(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        self.definesPresentationContext = true
        searchController.searchBar.barTintColor = UtilityManager.sharedInstance.backgroundColorForSearchBar
        
        
        self.tableView.tableHeaderView = searchController.searchBar
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredElements = arrayOfElements.filter { element in
            
            return element.descriptionGist!.lowercased().contains(searchText.lowercased()) || element.userLogin!.lowercased().contains(searchText.lowercased())
            
        }
        
        self.tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            return filteredElements.count
            
        }
        
        return arrayOfElements.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GistCustomTableViewCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            cell.setData(newGistData: filteredElements[indexPath.row])
            
        } else {
            
            cell.setData(newGistData: arrayOfElements[indexPath.row])
            
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110.0 * UtilityManager.sharedInstance.conversionHeight
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var urlString = ""
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            urlString = filteredElements[indexPath.row].hasOne!.rawURL!
            
        } else {
            
            urlString = arrayOfElements[indexPath.row].hasOne!.rawURL!
            
        }
        
        UtilityManager.sharedInstance.showLoader()
        
        ServerManager.sharedInstance.getFileInfo(url: urlString, actionsToDoWhenSucceeded: { (htmlInfo) in
            
            UtilityManager.sharedInstance.hideLoader()
            
            let detailFileVC = GistFileDetailViewController.init(urlOfFile: htmlInfo)
            self.navigationController?.pushViewController(detailFileVC, animated: true)
            
        }, actionsToDoWhenFailed: {
        
            UtilityManager.sharedInstance.hideLoader()
        
        })
        
    }
    
    @objc private func getInfoFromServer() {
        
        UtilityManager.sharedInstance.showLoader()
        
        ServerManager.sharedInstance.getAllTheGists(actionsToDoWhenSucceeded: { (arrayOfGists) in

            let simpleGists = self.getAllGistsLikeJustGist()

            let nonExistentGistsInCoreData = self.getNonExistentelements(arrayFromServer: arrayOfGists, arrayFromCoreData: simpleGists)
        
            self.insert(arrayOfGists: nonExistentGistsInCoreData)
            let arrayOfGistsFromCoreData = self.getAllGists()
            
            self.searchController.isActive = false
             self.refreshControl?.endRefreshing()
        
            self.arrayOfElements = arrayOfGistsFromCoreData
            self.filteredElements = arrayOfGistsFromCoreData
            
            self.tableView.reloadData()
            
            UtilityManager.sharedInstance.hideLoader()
            
            
        }, actionsToDoWhenFailed: {
            
            UtilityManager.sharedInstance.hideLoader()
            
            let alertController = UIAlertController(title: "ERROR",
                                                    message: "Connection error. We'll show the info saved in the device",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
                let arrayOfGistsFromCoreData = self.getAllGists()
                
                self.searchController.isActive = false
                self.refreshControl?.endRefreshing()
                
                self.arrayOfElements = arrayOfGistsFromCoreData
                self.filteredElements = arrayOfGistsFromCoreData
                
                self.tableView.reloadData()
                
            }
            
            alertController.addAction(cancelAction)
            
            let actualController = UtilityManager.sharedInstance.currentViewController()
            actualController.present(alertController, animated: true, completion: nil)
            
            
        })
        
    }
    
    private func insert(arrayOfGists: Array<Gist>) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        for gist in arrayOfGists {
            
            let newGist = NSEntityDescription.insertNewObject(forEntityName: "GistCD", into: context)
            newGist.setValue(gist.id, forKey: "id")
            newGist.setValue(gist.avatarURL, forKey: "avatarURL")
            newGist.setValue(gist.commentsURL, forKey: "commentsURL")
            newGist.setValue(gist.createdAt, forKey: "createdAt")
            newGist.setValue(gist.descriptionGist, forKey: "descriptionGist")
            newGist.setValue(gist.numberOfComments, forKey: "numberOfComments")
            newGist.setValue(gist.url, forKey: "url")
            newGist.setValue(gist.userLogin, forKey: "userLogin")
            
            let newFile = NSEntityDescription.insertNewObject(forEntityName: "FileCD", into: context)
            newFile.setValue(gist.file.name, forKey: "name")
            newFile.setValue(gist.file.language, forKey: "language")
            newFile.setValue(gist.file.rawURL, forKey: "rawURL")
            newFile.setValue(gist.file.size, forKey: "size")
            newFile.setValue(gist.file.type, forKey: "type")
            
            newGist.setValue(newFile, forKey: "hasOne")
 
        }
        
        do {
            
            try context.save()
            
        } catch {
            
            
            
        }
        
        
    }
    
    private func getAllGists() -> Array<GistCD> {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GistCD")
        request.returnsObjectsAsFaults = false
        
        var arrayOfGistCD = Array<GistCD>()
        
        do {
            
            arrayOfGistCD = try context.fetch(request) as! Array<GistCD>
            
        } catch {
            
            let alertController = UIAlertController(title: "ERROR",
                                                    message: "Error from internal data base, close and reopen the app",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
                
            }
            
            alertController.addAction(cancelAction)
            
            let actualController = UtilityManager.sharedInstance.currentViewController()
            actualController.present(alertController, animated: true, completion: nil)
            
        }
        
        return arrayOfGistCD.sorted{ $0.createdAt! > $1.createdAt! }
        
    }
    
    private func getAllGistsLikeJustGist() -> Array<Gist> {
        
        let allGistsCD = self.getAllGists()
        
        var arrayOfSimpleGists = Array<Gist>()
        
        for gistCD in allGistsCD {
            
            let newFile = File.init(newName: gistCD.hasOne!.name!,
                                    newType: gistCD.hasOne!.type!,
                                newLanguage: gistCD.hasOne!.language!,
                                  newRawURL: gistCD.hasOne!.rawURL!,
                                    newSize: Int(gistCD.hasOne!.size))
            
            arrayOfSimpleGists.append(Gist.init(newId: gistCD.id!,
                                               newURL: gistCD.url!,
                                              newFile: newFile,
                                       newDescription: gistCD.descriptionGist!,
                                  newNumberOfComments: Int(gistCD.numberOfComments),
                                       newCommentsURL: gistCD.commentsURL!,
                                         newAvatarURL: gistCD.avatarURL!,
                                         newUserLogin: gistCD.userLogin!,
                                         newCreatedAt: gistCD.createdAt!))
            
        }
        
        return arrayOfSimpleGists
        
    }
    
    private func getNonExistentelements(arrayFromServer: Array<Gist>, arrayFromCoreData: Array<Gist>) -> Array<Gist> {
        
        if arrayFromCoreData.count > 0 {
            
            var arrayOfNonExistingInCoreData = Array<Gist>()
            
            for serverGist in arrayFromServer {
                
                for i in 0...arrayFromCoreData.count - 1 {
                    
                    if arrayFromCoreData[i].id == serverGist.id {
                        
                        break
                        
                    } else {
                        
                        if i == arrayFromCoreData.count - 1 {
                            
                            arrayOfNonExistingInCoreData.append(serverGist)
                            
                            break
                            
                        }
                        
                    }
                    
                }
                
            }
            
            return arrayOfNonExistingInCoreData
            
        } else {
            
            return arrayFromServer
            
        }
        
    }
    
}

extension GistListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        self.filterContentForSearchText(searchText: searchController.searchBar.text!)
        
    }
    
}

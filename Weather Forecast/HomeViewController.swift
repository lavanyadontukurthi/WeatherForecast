//
//  HomeViewController.swift
//  Weather Forecast
//
//  Created by Lavanya on 12/19/17.
//  Copyright © 2017 Lavanya. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var weatherViewModel:WeatherViewModel!
    
    @IBOutlet weak var table:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherViewModel = WeatherViewModel()
        weatherViewModel.weatherViewModelProtocol = self
        
        table.estimatedRowHeight = 100
        table.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: UITableview Methods
extension HomeViewController:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return weatherViewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel.rowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let screenWidth = UIScreen.main.bounds.width
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        bgView.backgroundColor = UIColor.groupTableViewBackground
        
        let dayLabel = UILabel(frame: CGRect(x: 15, y: 0, width: screenWidth - 30, height: 30))
        dayLabel.text = weatherViewModel.days[section]
        dayLabel.font = UIFont.boldSystemFont(ofSize: 18)
        dayLabel.textAlignment = .center
        
        bgView.addSubview(dayLabel)
        
        return bgView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return weatherViewModel.cellInstance(tableView, indexPath)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        searchBar.resignFirstResponder()
    }
}

//MARK:UISearchBarDelegate methods
extension HomeViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchStr = searchBar.text
        if let searchStr = searchStr, searchStr.count > 0  {
            weatherViewModel.getWeatherForecast(searchStr: searchStr)
        }
        searchBar.resignFirstResponder()
    }
}


//MARK: WeatherViewModelProtocol Methods
extension HomeViewController:WeatherViewModelProtocol {
    
    func weatherForecastFetchSucceded() {
        self.table.reload {
            self.table.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    func weatherForecastFetchFailed(errorDescription: String) {
        let alertController = UIAlertController(title: "Error", message: errorDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UITableView {

    func reload(onCompletion:@escaping ()->()){

        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }) { (status) in
            onCompletion()
        }
    }

}


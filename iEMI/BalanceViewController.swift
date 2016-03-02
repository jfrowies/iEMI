//
//  BalanceViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 2/6/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class BalanceViewController: NetworkActivityViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var creditBalanceView: CreditBalanceView!

    private var refreshControl: UIRefreshControl!
    private var tableElements = [Transaction]()
    private var parkingSelected: Parking?
    private var sectionItemCount = [Int]()
    private var sectionFirstItem = [Int]()
    private var balance = 0.0
    
    let service: AccountEMIService = AccountEMIService()
    let licensePlateSotrage = LicensePlate()
    
    private let kCreditBalanceHeaderViewNibName = "CreditBalanceHeaderView"
    private let kCreditBalanceHeaderViewReuseId = "CreditBalanceHeaderViewReuseId"
    
    private let kBalanceCellDefaultHeight: CGFloat = 62.0
    private let kBalanceHeaderDefaultHeight: CGFloat = 30.0

    //MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh(self)
    
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.tintColor = UIColor.orangeGlobalTintColor()
        refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
        tableView.addSubview(refreshControl)
        
        let nib = UINib(nibName: kCreditBalanceHeaderViewNibName, bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: kCreditBalanceHeaderViewReuseId)
        
        let tableViewInsets = UIEdgeInsetsMake(0.0, 0.0, (self.tabBarController?.tabBar.frame.size.height)!, 0.0)
        
        tableView.contentInset = tableViewInsets
        tableView.scrollIndicatorInsets = tableViewInsets
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if refreshControl.refreshing {
            refreshControl.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -

    func reloadData(patente patente: String) {
        self.reloadTableHeaderData(patente: patente)
        self.reloadTableData(patente: patente)
    }
    
    func reloadTableData(patente patente: String) {
        
        service.balance(licensePlate: patente) { [unowned self]  (result) -> Void in
            do {
                let transactions = try result()
                self.tableElements = transactions
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                if transactions.count == 0 {
                    self.tableView.hidden = true
                } else {
                    self.tableView.hidden = false
                }
                self.hideLoadingView(animated: true)
                
            } catch let error{
                self.tableView.hidden = false
                self.showError(error as NSError)
            }
        }
    }
    
    
    private let kCreditBalanceText = NSLocalizedString("Credit balance", comment: "Credit balancen title text")
    private let kCreditBalanceSeparator = ": "
    private let kCreditBalanceSign = " $"
    
    private let kUnknownCreditBalance = NSLocalizedString("Unknown", comment: "Unknown credit balance")
    
    func reloadTableHeaderData(patente licensePlate: String) {
        
        service.accountBalance(licensePlate: licensePlate) { [unowned self] (result) -> Void in
            do {
                
                let currentBalance = try result()
                self.balance = currentBalance
                let creditBalanceString = String(format: "%.2f", currentBalance)
                self.creditBalanceView?.creditBalanceLabel.text = self.kCreditBalanceText + self.kCreditBalanceSeparator + creditBalanceString + self.kCreditBalanceSign

            } catch let error{
                
                self.creditBalanceView?.creditBalanceLabel.text = self.kCreditBalanceText + self.kCreditBalanceSeparator + self.kUnknownCreditBalance
                self.balance = 0.0
                self.showError(error as NSError)
            }
        }
    }
    
    private let kErrorText = NSLocalizedString("Error loading balance, please try again later.", comment: "error loading balance text")
    
    func showError(error: NSError?) {
        
        print("Error: \(error)")
        self.showErrorView(kErrorText, animated:false)
    }
    
    //MARK: - IBAction
    
    private let kLoadingCreditText = NSLocalizedString("Loading balance", comment: "loading credit balance text")

    @IBAction func refresh(sender:AnyObject) {
        if let currentLicensePlate = licensePlateSotrage.currentLicensePlate {
            if !(sender.isEqual(self.refreshControl)) {
                self.showLoadingView(kLoadingCreditText, animated:false)
            }
            self.reloadData(patente:currentLicensePlate)
        }
    }
    
    //MARK: - UITableViewDelegate implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        self.sectionItemCount.removeAll(keepCapacity: false)
        self.sectionFirstItem.removeAll(keepCapacity: false)
        var sections = 0;
        var date: String = "";
        var index: Int = 0;
        var newSaldo = self.balance
        for mov: Transaction in self.tableElements {
            let timestamp: String = mov.timestamp
            let subDate = timestamp.substringToIndex(timestamp.startIndex.advancedBy(10))
            if (!(date == subDate)) {
                date = subDate
                self.sectionItemCount.append(0)
                self.sectionFirstItem.append(index)
                sections++
            }
            
            mov.balance = String(format: "%.2f $", newSaldo)
            if (mov.isKindOfClass(Debit))
            {
                let amount = (mov as! Debit).amount
                newSaldo += (amount! as NSString).doubleValue
            }
            if (mov.isKindOfClass(Credit))
            {
                let amount = (mov as! Credit).amount
                newSaldo -= (amount! as NSString).doubleValue
            }
            
            self.sectionItemCount[sections - 1] = self.sectionItemCount[sections - 1] + 1
            index++
        }
        return sections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sectionItemCount[section]
    }
    
    private let kCreditCellReuseId = "creditoCell"
    private let kDebitCellReuseId = "consumoCell"
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let movimiento = self.tableElements[self.sectionFirstItem[indexPath.section] + indexPath.row]
        
        if movimiento.isKindOfClass(Credit) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(kCreditCellReuseId, forIndexPath: indexPath) as! CreditoTableViewCell
            cell.credito = movimiento as! Credit
            return cell
        }
        
        if movimiento.isKindOfClass(Debit) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(kDebitCellReuseId, forIndexPath: indexPath) as! ConsumoTableViewCell
            cell.consumo = movimiento as! Debit
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if let debit = self.tableElements[self.sectionFirstItem[indexPath.section] + indexPath.row] as? Debit {
            self.parkingSelected = Parking(number: debit.number!, year: debit.year!, serie: debit.serie!)
        }else{
            return nil
        }
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kBalanceCellDefaultHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(kCreditBalanceHeaderViewReuseId) as? CreditBalanceHeaderView
        
        let mov = self.tableElements[self.sectionFirstItem[section]];
        let timestamp: String = mov.timestamp
        let subDate = timestamp.substringToIndex(timestamp.startIndex.advancedBy(10))
        let nsDate = NSDate(dateString: subDate)
        
        headerView?.sectionTitleLabel.text = nsDate.formattedDateString()
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kBalanceHeaderDefaultHeight
    }
    
    // MARK: - Navigation
    
    private let kShowParkingInformationSegueId = "showParkingInformation"
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kShowParkingInformationSegueId {
            let dvc = segue.destinationViewController as! ParkingInformationViewController
            dvc.parking = self.parkingSelected
        }
    }
    
}

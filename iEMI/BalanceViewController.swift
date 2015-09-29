//
//  BalanceViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 2/6/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class BalanceViewController: NetworkActivityViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!

    var refreshControl: UIRefreshControl!
    var tableElements = [Transaction]()
    var parkingSelected: Parking?
    var sectionItemCount = [Int]()
    var sectionFirstItem = [Int]()
    var balance = 0.0
    var creditBalanceView: CreditBalanceView?
    
    let service: AccountService = AccountEMIService()
    let licensePlateSotrage = LicensePlate()

    
    //MARK: - View controller lifecycle
    
    let kTableHeaderHeight = 60.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentLicensePlate = licensePlateSotrage.currentLicensePlate {
            self.reloadData(patente:currentLicensePlate)
        }
    
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.tintColor = UIColor.orangeGlobalTintColor()
        self.refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
        self.tableView.addSubview(refreshControl)
        
        //TableHeaderView initialization
        let screenWidth:Double = Double(UIScreen.mainScreen().bounds.size.width);
       
        let headerViewFrame: CGRect = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: kTableHeaderHeight)
        
        self.creditBalanceView = CreditBalanceView(frame: headerViewFrame)
        self.tableView.tableHeaderView = self.creditBalanceView

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
                self.hideLoadingView(animated: true)
                
            } catch let error{
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let mov = self.tableElements[self.sectionFirstItem[section]];
        
        let timestamp: String = mov.timestamp
        let subDate = timestamp.substringToIndex(timestamp.startIndex.advancedBy(10))
        
        let nsDate = NSDate(dateString: subDate)
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        return formatter.stringFromDate(nsDate)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sectionItemCount[section]
    }
    
    let kCreditCellReuseId = "creditoCell"
    let kDebitCellReuseId = "consumoCell"
    
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
        return 50.0
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//    }
    
    // MARK: - Navigation
    
    let kShowParkingInformationSegueId = "showParkingInformation"
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kShowParkingInformationSegueId {
            let dvc = segue.destinationViewController as! ParkingInformationViewController
            dvc.parking = self.parkingSelected
        }
    }
    
}

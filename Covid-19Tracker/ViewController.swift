//
//  ViewController.swift
//  Covid-19Tracker
//
//  Created by Mayur Parmar on 16/04/20.
//  Copyright © 2020 Mayur Parmar. All rights reserved.
//

import UIKit
import Alamofire
import Charts

class ViewController: UIViewController ,ChartViewDelegate {
    
    //MARK: Outlets & variable declaration
    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var totalView: UIView!
    @IBOutlet var recoveredView: UIView!
    @IBOutlet var dethsView: UIView!
    @IBOutlet var percOneView: UIView!
    @IBOutlet var percTwoView: UIView!
    
    @IBOutlet var chartView: BarChartView!
    @IBOutlet var infoView: UIView!
    @IBOutlet var avoidInfactionView: UIView!
    @IBOutlet var seflAssesmentView: UIView!
    
    @IBOutlet var lblTotalCase: UILabel!
    @IBOutlet var lblTotalRecover: UILabel!
    @IBOutlet var lblTotalDeaths: UILabel!
    @IBOutlet var lblMortality: UILabel!
    @IBOutlet var lblRecoveryRate: UILabel!
    
    
    @IBOutlet var txtInfo: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchJson()
    }
      
    
    // Setup UI
    func setupUI() {
                  
        roundedBorderView(view : totalView, color: .orange )
        roundedBorderView(view : recoveredView, color: .orange )
        roundedBorderView(view : dethsView, color: .orange )
        roundedBorderView(view : percOneView, color: .blue )
        roundedBorderView(view : percTwoView, color: .blue )
        roundedBorderView(view : chartView, color: .blue )
        roundedBorderView(view : infoView, color: .blue )
        roundedBorderView(view : avoidInfactionView, color: .red )
        roundedBorderView(view : seflAssesmentView, color: .red )
        roundedBorderImage(image: imgLogo, color: .orange)
      
        chartView.xAxis.labelPosition = .bottom
        chartView.noDataText = "Fetching Data."
    }
    
    
    // Setup UI After API Call
    func setData(data: [String: Any]) {
        let totalConfirmed = data["totalConfirmed"] as? Double
        let totalDeaths = data["totalDeaths"] as? Double
        let totalRecovered = data["totalRecovered"] as? Double
        let arrCountry = ["unitedstates","spain","italy","france","unitedkingdom","chinamainland","canada"]
        var arrChar = [NSDictionary]()
        
        var localConfirm = 0.0
        var localDeaths = 0.0
        var localRecovered = 0.0
        
        var arrData = [String: Double]()
        
        if let arrAreas = data["areas"] as? [[String: Any]] {
            for i in arrAreas {
                let country = i["id"] as! String
                if country == "canada" {
                    localConfirm = (i["totalConfirmed"] as? Double)!
                    localDeaths =  (i["totalDeaths"] as? Double)!
                    localRecovered =  (i["totalRecovered"] as? Double)!
                }
            }
        }
        
        
        if let arrAreas = data["areas"] as? [[String: Any]] {
            for i in arrAreas {
                let country = i["id"] as! String
                if arrCountry.contains(country) {
                    arrData = [country: (i["totalConfirmed"] as? Double)! ]
                    arrChar.append(arrData as NSDictionary)
                }
            }
        }
        
        setChart(data: arrChar)
        
        // global mortalityRate and recoveryRate calculation
        let mortalityRate = totalDeaths! / totalConfirmed!
        let recoveryRate = totalRecovered! / totalConfirmed!
        
        // local mortalityRate and recoveryRate calculation
        let localMortalityRate = localDeaths / localConfirm
        let localRecoveryRate = localRecovered / localConfirm
        
        lblTotalCase.text = String(format:"%.0f", totalConfirmed!)
        lblTotalDeaths.text = String(format:"%.0f", totalDeaths!)
        lblTotalRecover.text = String(format:"%.0f", totalRecovered!)
        lblMortality.text = "\(String(format:"%.4f", mortalityRate))" + "%"
        lblRecoveryRate.text = "\(String(format:"%.4f", recoveryRate))" + "%"
        txtInfo.text = "Canada\nTotal Confirmed : \(localConfirm)\nTotal Deaths : \(localDeaths)\nTotal Recovered : \(localRecovered)\nMortality Rate : \(String(format:"%.4f", localMortalityRate))" + "%\nRecovery Rate : \(String(format:"%.4f", localRecoveryRate))" + "%"
         
    }
    
    
    //MARK:- Setup Chart Data
    func setChart(data:[NSDictionary]){
        let country = ["USA", "spain" ,"italy", "france", "UK", "China", "Canada"]
        var totalCase = [Double]()
         
        for item  in data  {
            let obj = item as NSDictionary
            for (key, value) in obj {
                print("Country: \"\(key as! String)\"")
                totalCase.append(value as! Double)
            }
        }
        
        chartView.setBarChartData(xValues: country, yValues: totalCase, label: "Confirmed Cases")
    }
    
    // Apply border and rounded cornder to View
    func roundedBorderView(view: UIView, color: UIColor) {
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = color.cgColor
    }
    
    // Apply border and rounded image
    func roundedBorderImage(image: UIImageView, color: UIColor) {
        image.layer.borderWidth = 2
        image.layer.masksToBounds = false
        image.layer.borderColor = color.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
    
    //MARK:- IBAction
    @IBAction func btnAvoidInfactionPress(_ sender: UIButton) {
        let avoidInfactionVC = storyboard?.instantiateViewController(identifier: "AvoidInfactionVC") as! AvoidInfactionVC
        self.navigationController?.pushViewController(avoidInfactionVC, animated: true)
    }
    
    
    @IBAction func btnSelfAssesmentPress(_ sender: UIButton) {
        let selfAssesmentVC = storyboard?.instantiateViewController(identifier: "SelfAssesmentVC") as! SelfAssesmentVC
        self.navigationController?.pushViewController(selfAssesmentVC, animated: true)
    }
    
    
    //MARK:- API Call
    func fetchJson() {
        Alamofire.request("https://www.bing.com/covid/data").responseJSON { (response) in
            if let jsonResponse = response.result.value {
                if let covidJson = jsonResponse as? [String: Any] {
                 print(covidJson)
                    self.setData(data:covidJson)
                }
            }
        }
    }
}



//MARK:- Chart Delegate
extension BarChartView {

    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
    
    func setBarChartData(xValues: [String], yValues: [Double], label: String) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<yValues.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yValues[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: label)
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        self.data = chartData
    }
}

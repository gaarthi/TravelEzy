//
//  DisplayWeatherViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 19/01/22.
//

import UIKit
import Charts
import SVProgressHUD

let appidConstant = "c0b1feef8919691dd37c4779eef5511a"

class DisplayWeatherViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var displayDateLabel: UILabel!
    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var cloudImageTopCtrn: NSLayoutConstraint!
    @IBOutlet weak var windImageTopCtrn: NSLayoutConstraint!
    @IBOutlet weak var planningLabelTopCtrn: NSLayoutConstraint!
    
    var tempValues = [NSNumber]()
    var days = [String]()
    weak var axisFormatDelegate: IAxisValueFormatter?
    typealias resultFromAPI = ((Bool) -> Void)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameLabel.text = selectedCityName
        setUI()
        fetchDateTime()
        axisFormatDelegate = self
        days = ["Day 1", "Day 2", "Day 3", "Day 4", "Day 5"]
        
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        callAPI { val1 in
            if val1 == true {
                
                self.callAPIForChart { val2 in
                    if val2 == true {
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self.view.isUserInteractionEnabled = true
                        }
                        self.setChart(dataEntryX: self.days, dataEntryY: self.tempValues)
                    }
                }
            }
        }
    }
    
    @IBAction func selectCityBtnTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CitySelectionViewController") as! CitySelectionViewController
        vc.height = 400
        self.present(vc, animated: true, completion: nil)
    }
    
    func setUI() {
        let name = UIDevice.current.name
        if name == "iPhone SE (2nd generation)" || name == "iPhone 8 Plus" {
            cloudImageTopCtrn.constant = 20
            windImageTopCtrn.constant = 10
        }
    }
    
    func fetchDateTime() {
        let currentDateTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone(abbreviation: timeZoneAbbreviation)
        let dateTimeString = dateFormatter.string(from: currentDateTime)
        let newDate = dateTimeString.components(separatedBy: " at ")
        displayDateLabel.text = newDate[0]
        displayTimeLabel.text = newDate[1]
    }
    
    func setChart(dataEntryX forX:[String],dataEntryY forY: [NSNumber]) {
        
        DispatchQueue.main.async {
            self.lineChart.noDataText = "Data is loading......"
            self.lineChart.rightAxis.enabled = false
            self.lineChart.backgroundColor = .white
            
            let yAxis = self.lineChart.leftAxis
            yAxis.labelPosition = .outsideChart
            yAxis.labelTextColor = .black
            yAxis.labelFont = .boldSystemFont(ofSize: 10)
            yAxis.axisLineColor = .black
            yAxis.drawGridLinesEnabled = true
            yAxis.gridColor = .lightGray
            
            let xAxis = self.lineChart.xAxis
            xAxis.labelPosition = .bottom
            xAxis.setLabelCount(4, force: true)
            xAxis.labelTextColor = .white
            xAxis.labelFont = .boldSystemFont(ofSize: 10)
            xAxis.axisLineColor = .black
            xAxis.drawGridLinesEnabled = true
            xAxis.gridColor = .lightGray
            
            var dataEntries:[ChartDataEntry] = []
            for i in 0..<forX.count{
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(forY[i]) , data: self.days as AnyObject?)
                dataEntries.append(dataEntry)
            }
            let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Temperature")
            chartDataSet.mode = .cubicBezier
            chartDataSet.drawCirclesEnabled = true
            chartDataSet.drawCircleHoleEnabled = false
            chartDataSet.setCircleColor(.black)
            chartDataSet.circleRadius = 4
            chartDataSet.setColor(#colorLiteral(red: 0.003499795916, green: 0.7116407752, blue: 0.7581144571, alpha: 1))
            chartDataSet.lineWidth = 3
            
            let chartData = LineChartData(dataSet: chartDataSet)
            chartData.setDrawValues(false)
            self.lineChart.data = chartData
            
            let xAxisValue = self.lineChart.xAxis
            xAxisValue.valueFormatter = self.axisFormatDelegate
        }
    }
    
    func callAPI(resultOne: @escaping resultFromAPI)  {
        
        let rootURL = "https://api.openweathermap.org/data/2.5/weather?q=\(selectedCityName)&appid=\(appidConstant)&units=metric"
        
        WebService.sharedInstance.performRequest(url: rootURL) { rootData in
            let mainData = rootData["main"] as? [String:Any]
            let weatherData = rootData["weather"] as? [[String:Any]]
            let windData = rootData["wind"] as? [String:Any]
            
            if let myData = mainData {
                let temp = myData["temp"] as! Double
                let humidity = myData["humidity"] as! NSNumber
                DispatchQueue.main.async {
                    self.temperatureLabel.text = String(format: "%.2f", temp) + " °C"
                    self.humidityLabel.text = String(describing: humidity) + " %"
                }
            }
            
            if let weatherInput = weatherData {
                for eachItem in weatherInput {
                    let description = eachItem["main"] as! String
                    DispatchQueue.main.async {
                        self.weatherDescriptionLabel.text = String(describing: description)
                    }
                }
            }
            
            if let windInfo = windData {
                let windSpeed = windInfo["speed"] as! NSNumber
                DispatchQueue.main.async {
                    self.windLabel.text = String(describing: windSpeed) + " m/s"
                }
            }
            resultOne(true)
        }
    }
    
    func callAPIForChart(resultTwo: @escaping resultFromAPI)  {
        
        let latForCity = latitudeForCity(selectedCity: selectedCityName)
        let longForCity = longitudeForCity(selectedCity: selectedCityName)
        
        let rootURLForChartData = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latForCity)&lon=\(longForCity)&exclude=current,hourly,minutely&appid=\(appidConstant)&units=metric"
        
        WebService.sharedInstance.performRequest(url: rootURLForChartData) { rootData in
            let mainData = rootData["daily"] as! [[String:Any]]
            for each in mainData {
                let temp = each["temp"] as! [String:Any]
                let day = temp["day"] as! NSNumber
                self.tempValues.append(day)
            }
            resultTwo(true)
        }
    }
}

extension DisplayWeatherViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return days[Int(value)]
    }
}

//
//  ViewController.swift
//  Calendar
//
//  Created by gandrey on 29/03/2020.
//  Copyright © 2020 GlAndrey. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    

    @IBOutlet weak var calendarView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    
    let Months = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресение"]
    var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    var currentMonth = String()
    
    var numberOfEmptyBox = Int()    // The number  of "empty boxes" at the start of the current month
    var nextNumberOfEmptyBox = Int()// The same with above but with the next month
    var prevNumberOfEmptyBox = 0    // The same but with the past month
    var direction = 0               // = 0 if current month, = 1 if we are in a future month, = -1 if we are in a past month
    var positionIndex = 0           // here we will store the above vars of the empty boxes
    var weekDayOn: Bool = false     // Is today weekend?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currentMonth = Months[month]
        monthLabel.text = "\(currentMonth) \(year)"
       
        if weekday == 0 {
            weekday = 7
        }
        if weekday == 6 || weekday == 7 {
            weekDayOn = true
        } else {
            weekDayOn = false
        }
        getStartDateDayPosition()
    }

    
    
    @IBAction func nextButton(_ sender: Any) {
        switch currentMonth {
        case "Декабрь":
            month = 0
            year += 1
            direction = 1
            getStartDateDayPosition()
            
        default:
            direction = 1
            getStartDateDayPosition()
            month += 1
        }
        currentMonth = Months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        calendarView.reloadData()
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        switch currentMonth {
        case "Январь":
            month = 11
            year -= 1
            direction = -1
            getStartDateDayPosition()
            
        default:
            month -= 1
            direction = -1
            getStartDateDayPosition()
        }
        currentMonth = Months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        calendarView.reloadData()
        
    }
    
    func getStartDateDayPosition() {    // this function gives us the number of empty boxes
        
        if year%4 == 0 {
            daysInMonth[1] = 29
        } else {
            daysInMonth[1] = 28
        }
        
        switch direction {
        case 0:                         //  if we are at the current month
            switch day {
            case 1...7:
                numberOfEmptyBox = weekday - day
            case 8...14:
                numberOfEmptyBox = weekday - (day - 7)
            case 15...21:
                numberOfEmptyBox = weekday - (day - 14)
            case 22...28:
                numberOfEmptyBox = weekday - (day - 21)
            case 29...31:
                numberOfEmptyBox = weekday - (day - 28)
            default:
                break
            }
            positionIndex = numberOfEmptyBox
        case 1...:                                                          //  if we are at a future month
            nextNumberOfEmptyBox = (positionIndex + daysInMonth[month])%7
            positionIndex = nextNumberOfEmptyBox
        case -1:                                                            //  if we are at a past month
            prevNumberOfEmptyBox = 7 - (daysInMonth[month] - positionIndex)%7
            if prevNumberOfEmptyBox == 7 {
                prevNumberOfEmptyBox = 0
            }
            positionIndex = prevNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        switch direction {
        case 0:
            return daysInMonth[month] + numberOfEmptyBox
        case 1...:
            return daysInMonth[month] + nextNumberOfEmptyBox
        case -1:
            return daysInMonth[month] + prevNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.dateLabel.textColor = UIColor.black
        if cell.isHidden {
            cell.isHidden = false
        }
        
        switch direction {
        case 0:
            cell.dateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        case 1...:
            cell.dateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
        case -1:
            cell.dateLabel.text = "\(indexPath.row + 1 - prevNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        if Int(cell.dateLabel.text!)! < 1 {
            cell.isHidden = true
        }
        
        // show the weekend days in different color
        switch indexPath.row {
        case 5, 6, 12, 13, 19, 20, 26, 27, 33, 34:
            if Int(cell.dateLabel.text!)! > 0 {
                cell.dateLabel.textColor = UIColor.red
            }
        default:
            break
        }
        
        // mark red the cell the shows the current date
        
        if currentMonth == Months[calendar.component(.month, from: date) - 1] &&
            year == calendar.component(.year, from: date) &&
            indexPath.row  == numberOfEmptyBox + day - 1 {
            if weekDayOn {
                cell.dateLabel.textColor = UIColor.white
            }
            cell.backgroundColor = UIColor.red
        }
        
        
        return cell
        
    }
    

}


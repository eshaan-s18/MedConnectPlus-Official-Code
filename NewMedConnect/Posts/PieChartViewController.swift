//
//  PieChartViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 10/3/22.
//

import UIKit
import SwiftUI
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore
import BLTNBoard
import Charts

var selectedPieChartResponse:String = ""
var selectedGenderVotes:[Int] = []
var selectedRaceVotes:[Int] = []
var selectedAgeVotes:[Int] = []
var selectedCountry:[String] = []
var selectedCountryVotes:[Int] = []



class PieChartViewController: UIViewController {
    
    @IBOutlet weak var filterControl: UISegmentedControl!
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var selectedResponseLabel: UILabel!
    
    @IBOutlet weak var selectedResponseView: UIView!
    
    
    //GENDER VARIABLEs
    var maleDataEntry = PieChartDataEntry(value: 0)
    var femaleDataEntry = PieChartDataEntry(value: 0)
    var otherDataEntry = PieChartDataEntry(value: 0)
    
    //RACE VARIABLES
    var whiteDataEntry = PieChartDataEntry(value: 0)
    var blackDataEntry = PieChartDataEntry(value: 0)
    var indianAlaskaDataEntry = PieChartDataEntry(value: 0)
    var asianDataEntry = PieChartDataEntry(value: 0)
    var hawaiianIslanderDataEntry = PieChartDataEntry(value: 0)


    //AGE RANGE VARIABLES
    var zeroToTenDataEntry = PieChartDataEntry(value: 0)
    var tenToTwentyDataEntry = PieChartDataEntry(value: 0)
    var twentyToThirtyDataEntry = PieChartDataEntry(value: 0)
    var thirtyToFourtyDataEntry = PieChartDataEntry(value: 0)
    var fourtyToFiftyDataEntry = PieChartDataEntry(value: 0)
    var fiftyToSixtyDataEntry = PieChartDataEntry(value: 0)
    var sixtyToSeventyDataEntry = PieChartDataEntry(value: 0)
    var seventyToEightyDataEntry = PieChartDataEntry(value: 0)
    var eightyPlusDataEntry = PieChartDataEntry(value: 0)
 
    //COUNTRY VARIABLES --> SET UP LATER BECAUSE # VARIES
    
    var numberOfUpvotesDataEntries = [PieChartDataEntry]()
    
    var filter = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedResponseLabel.text = selectedPieChartResponse
        
        pieChart.chartDescription.text = "Graph displays upvotes by category"
        
        
        pieChart.centerText = "Filtered By: Gender"
        
        
        maleDataEntry.value = Double(selectedGenderVotes[0])
        maleDataEntry.label = "Male"
        
        femaleDataEntry.value = Double(selectedGenderVotes[1])
        femaleDataEntry.label = "Female"
        
        otherDataEntry.value = Double(selectedGenderVotes[2])
        otherDataEntry.label = "Other"
        
        filter = "Gender"
        
        selectedResponseView.layer.cornerRadius = 10
        
        numberOfUpvotesDataEntries = [maleDataEntry, femaleDataEntry, otherDataEntry]
        
        updateChartData()
        
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func filterValueChanged(_ sender: Any) {
        switch filterControl.selectedSegmentIndex {
        case 0:
            print("gender")
            pieChart.centerText = "Filtered By: Gender"

            maleDataEntry.value = Double(selectedGenderVotes[0])
            maleDataEntry.label = "Male"
            
            femaleDataEntry.value = Double(selectedGenderVotes[1])
            femaleDataEntry.label = "Female"
            
            otherDataEntry.value = Double(selectedGenderVotes[2])
            otherDataEntry.label = "Other"
            
            filter = "Gender"
            
            numberOfUpvotesDataEntries = [maleDataEntry, femaleDataEntry, otherDataEntry]
            
            updateChartData()
            
        case 1:
            print("Age")
            pieChart.centerText = "Filtered By: Age"

            zeroToTenDataEntry.value = Double(selectedAgeVotes[0])
            zeroToTenDataEntry.label = "Ages 1-10"
            
            tenToTwentyDataEntry.value = Double(selectedAgeVotes[1])
            tenToTwentyDataEntry.label = "Ages 11-20"
            
            twentyToThirtyDataEntry.value = Double(selectedAgeVotes[2])
            twentyToThirtyDataEntry.label = "Ages 21-30"
            
            thirtyToFourtyDataEntry.value = Double(selectedAgeVotes[3])
            thirtyToFourtyDataEntry.label = "Ages 31-40"
            
            fourtyToFiftyDataEntry.value = Double(selectedAgeVotes[4])
            fourtyToFiftyDataEntry.label = "Ages 41-0"
            
            fiftyToSixtyDataEntry.value = Double(selectedAgeVotes[5])
            fiftyToSixtyDataEntry.label = "Ages 51-60"
            
            sixtyToSeventyDataEntry.value = Double(selectedAgeVotes[6])
            sixtyToSeventyDataEntry.label = "Ages 61-70"
            
            seventyToEightyDataEntry.value = Double(selectedAgeVotes[7])
            seventyToEightyDataEntry.label = "Ages 71-80"
            
            eightyPlusDataEntry.value = Double(selectedAgeVotes[8])
            eightyPlusDataEntry.label = "Ages 81+"
   
            filter = "Age"
            
            numberOfUpvotesDataEntries = [zeroToTenDataEntry, tenToTwentyDataEntry, twentyToThirtyDataEntry, thirtyToFourtyDataEntry, fourtyToFiftyDataEntry, fiftyToSixtyDataEntry, sixtyToSeventyDataEntry, seventyToEightyDataEntry, eightyPlusDataEntry]
            
            updateChartData()
            
            
        case 2:
            print("race")
            pieChart.centerText = "Filtered By: Race"

            whiteDataEntry.value = Double(selectedRaceVotes[0])
            whiteDataEntry.label = "White"
            
            blackDataEntry.value = Double(selectedRaceVotes[1])
            blackDataEntry.label = "Black or African American"
            
            indianAlaskaDataEntry.value = Double(selectedRaceVotes[2])
            indianAlaskaDataEntry.label = "American Indian or Alaska Native"
            
            asianDataEntry.value = Double(selectedRaceVotes[3])
            asianDataEntry.label = "Asian"
            
            hawaiianIslanderDataEntry.value = Double(selectedRaceVotes[4])
            hawaiianIslanderDataEntry.label = "Native Hawaiian or Other Pacific Islander"
            
            filter = "Race"
            
            numberOfUpvotesDataEntries = [whiteDataEntry, blackDataEntry, indianAlaskaDataEntry, asianDataEntry, hawaiianIslanderDataEntry]
            
            updateChartData()
            
        case 3:
            print("country")
            pieChart.centerText = "Filtered By: Country"
            numberOfUpvotesDataEntries = [PieChartDataEntry]()
            var i = 0
            while i < selectedCountry.count {
                
                numberOfUpvotesDataEntries.append(PieChartDataEntry(value: Double(selectedCountryVotes[i]), label: selectedCountry[i]))
                i+=1
                                                
            }
            
            filter = "Country"
            
            updateChartData()
                                                  
                                                

            
        default:
            print("error")
        }
    }
    

    
    func updateChartData() {
        let chartDataSet = PieChartDataSet(entries: numberOfUpvotesDataEntries, label: "")
        let chartData = PieChartData(dataSet: chartDataSet)
        var colors:[NSUIColor] = []
        
        if filter == "Gender"{
            if sharedDiscussionCommentUserGender == "Male" {
                colors = [UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0), UIColor.lightGray, UIColor.lightGray]
            }
            else if sharedDiscussionCommentUserGender == "Female" {
                 colors = [UIColor.lightGray, UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0), UIColor.lightGray]
            }
            else if sharedDiscussionCommentUserGender == "Other" {
                 colors = [UIColor.lightGray, UIColor.lightGray, UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0)]
            }
        }
        
        else if filter == "Age" {
            if sharedDiscussionCommentUserAge > 0 && sharedDiscussionCommentUserAge <= 10 {
                colors = [UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0), UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray]
            }
            else if sharedDiscussionCommentUserAge > 10 && sharedDiscussionCommentUserAge <= 20 {
                colors = [UIColor.lightGray, UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0), UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray]
            }
            else if sharedDiscussionCommentUserAge > 20 && sharedDiscussionCommentUserAge <= 30 {
                colors = [UIColor.lightGray, UIColor.lightGray, UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0), UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray]
            }
            else if sharedDiscussionCommentUserAge > 30 && sharedDiscussionCommentUserAge <= 40 {
                colors = [UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0), UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray]
            }
            else if sharedDiscussionCommentUserAge > 40 && sharedDiscussionCommentUserAge <= 50 {
                colors = [UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0), UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray]
            }
            else if sharedDiscussionCommentUserAge > 50 && sharedDiscussionCommentUserAge <= 60 {
                colors = [UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0), UIColor.lightGray, UIColor.lightGray, UIColor.lightGray]
            }
            else if sharedDiscussionCommentUserAge > 60 && sharedDiscussionCommentUserAge <= 70 {
                colors = [UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0), UIColor.lightGray, UIColor.lightGray]
            }
            else if sharedDiscussionCommentUserAge > 70 && sharedDiscussionCommentUserAge <= 80 {
                colors = [UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0), UIColor.lightGray]
            }
            else if sharedDiscussionCommentUserAge > 80 {
                colors = [UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0)]
            }
        }
        
        else if filter == "Race" {
            if sharedDiscussionCommentUserRace == "White" {
                colors = [UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0), UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray]
            }
            else if sharedDiscussionCommentUserRace == "Black or African American" {
                colors = [UIColor.lightGray, UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0), UIColor.lightGray, UIColor.lightGray, UIColor.lightGray]
            }
            else if sharedDiscussionCommentUserRace == "American Indian or Alaska Native" {
                colors = [UIColor.lightGray, UIColor.lightGray, UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0), UIColor.lightGray, UIColor.lightGray]
            }
            else if sharedDiscussionCommentUserRace == "Asian" {
                colors = [UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0), UIColor.lightGray]
            }
            else if sharedDiscussionCommentUserRace == "Native Hawaiian or Other Pacific Islander" {
                colors = [UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0)]
            }
        }
        
        else if filter == "Country" {
            var countryIndex = 0
            if selectedCountry.contains(sharedDiscussionCommentUserCountry) {
                countryIndex = selectedCountry.firstIndex(of: sharedDiscussionCommentUserCountry)!

            }
            
            else {
                countryIndex = selectedCountry.firstIndex(of: "")!
            }
            
            var i = 0
            while i < selectedCountry.count {
                colors.append(UIColor.lightGray)
                i+=1
            }
            
            colors[countryIndex] = UIColor(red: 0.056, green: 0.835, blue: 1.00, alpha: 1.0)
        }
        
        
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChart.data = chartData
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

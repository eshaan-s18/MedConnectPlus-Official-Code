//
//  EnterInformationViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 5/29/22.
//

import UIKit
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore

var sharedCountry = ""

// MARK: - Select Country Page
class EnterInformationViewController: UIViewController {
    
    @IBOutlet weak var countryPicker: UIPickerView!
    
    @IBOutlet weak var selectCountry: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    let db = Firestore.firestore()
    
    var countryList = [
        "🇺🇸  United States",
        "🇦🇨  Ascension Island",
        "🇦🇩  Andorra",
        "🇦🇪  United Arab Emirates",
        "🇦🇫  Afghanistan",
        "🇦🇬  Antigua & Barbuda",
        "🇦🇮  Anguilla",
        "🇦🇱  Albania",
        "🇦🇲  Armenia",
        "🇦🇴  Angola",
        "🇦🇶  Antarctica",
        "🇦🇷  Argentina",
        "🇦🇸  American Samoa",
        "🇦🇹  Austria",
        "🇦🇺  Australia",
        "🇦🇼  Aruba",
        "🇦🇽  Åland Islands",
        "🇦🇿  Azerbaijan",
        "🇧🇦  Bosnia & Herzegovina",
        "🇧🇧  Barbados",
        "🇧🇩  Bangladesh",
        "🇧🇪  Belgium",
        "🇧🇫  Burkina Faso",
        "🇧🇬  Bulgaria",
        "🇧🇭  Bahrain",
        "🇧🇮  Burundi",
        "🇧🇯  Benin",
        "🇧🇱  St. Barthélemy",
        "🇧🇲  Bermuda",
        "🇧🇳  Brunei",
        "🇧🇴  Bolivia",
        "🇧🇶  Caribbean Netherlands",
        "🇧🇷  Brazil",
        "🇧🇸  Bahamas",
        "🇧🇹  Bhutan",
        "🇧🇻  Bouvet Island",
        "🇧🇼  Botswana",
        "🇧🇾  Belarus",
        "🇧🇿  Belize",
        "🇨🇦  Canada",
        "🇨🇨  Cocos (Keeling) Islands",
        "🇨🇩  Congo - Kinshasa",
        "🇨🇫  Central African Republic",
        "🇨🇬  Congo - Brazzaville",
        "🇨🇭  Switzerland",
        "🇨🇮  Côte d’Ivoire",
        "🇨🇰  Cook Islands",
        "🇨🇱  Chile",
        "🇨🇲  Cameroon",
        "🇨🇳  China",
        "🇨🇴  Colombia",
        "🇨🇵  Clipperton Island",
        "🇨🇷  Costa Rica",
        "🇨🇺  Cuba",
        "🇨🇻  Cape Verde",
        "🇨🇼  Curaçao",
        "🇨🇽  Christmas Island",
        "🇨🇾  Cyprus",
        "🇨🇿  Czechia",
        "🇩🇪  Germany",
        "🇩🇬  Diego Garcia",
        "🇩🇯  Djibouti",
        "🇩🇰  Denmark",
        "🇩🇲  Dominica",
        "🇩🇴  Dominican Republic",
        "🇩🇿  Algeria",
        "🇪🇦  Ceuta & Melilla",
        "🇪🇨  Ecuador",
        "🇪🇪  Estonia",
        "🇪🇬  Egypt",
        "🇪🇭  Western Sahara",
        "🇪🇷  Eritrea",
        "🇪🇸  Spain",
        "🇪🇹  Ethiopia",
        "🇪🇺  European Union",
        "🇫🇮  Finland",
        "🇫🇯  Fiji",
        "🇫🇰  Falkland Islands",
        "🇫🇲  Micronesia",
        "🇫🇴  Faroe Islands",
        "🇫🇷  France",
        "🇬🇦  Gabon",
        "🇬🇧  United Kingdom",
        "🇬🇩  Grenada",
        "🇬🇪  Georgia",
        "🇬🇫  French Guiana",
        "🇬🇬  Guernsey",
        "🇬🇭  Ghana",
        "🇬🇮  Gibraltar",
        "🇬🇱  Greenland",
        "🇬🇲  Gambia",
        "🇬🇳  Guinea",
        "🇬🇵  Guadeloupe",
        "🇬🇶  Equatorial Guinea",
        "🇬🇷  Greece",
        "🇬🇸  South Georgia & South Sandwich Islands",
        "🇬🇹  Guatemala",
        "🇬🇺  Guam",
        "🇬🇼  Guinea-Bissau",
        "🇬🇾  Guyana",
        "🇭🇰  Hong Kong SAR China",
        "🇭🇲  Heard & McDonald Islands",
        "🇭🇳  Honduras",
        "🇭🇷  Croatia",
        "🇭🇹  Haiti",
        "🇭🇺  Hungary",
        "🇮🇨  Canary Islands",
        "🇮🇩  Indonesia",
        "🇮🇪  Ireland",
        "🇮🇱  Israel",
        "🇮🇲  Isle of Man",
        "🇮🇳  India",
        "🇮🇴  British Indian Ocean Territory",
        "🇮🇶  Iraq",
        "🇮🇷  Iran",
        "🇮🇸  Iceland",
        "🇮🇹  Italy",
        "🇯🇪  Jersey",
        "🇯🇲  Jamaica",
        "🇯🇴  Jordan",
        "🇯🇵  Japan",
        "🇰🇪  Kenya",
        "🇰🇬  Kyrgyzstan",
        "🇰🇭  Cambodia",
        "🇰🇮  Kiribati",
        "🇰🇲  Comoros",
        "🇰🇳  St. Kitts & Nevis",
        "🇰🇵  North Korea",
        "🇰🇷  South Korea",
        "🇰🇼  Kuwait",
        "🇰🇾  Cayman Islands",
        "🇰🇿  Kazakhstan",
        "🇱🇦  Laos",
        "🇱🇧  Lebanon",
        "🇱🇨  St. Lucia",
        "🇱🇮  Liechtenstein",
        "🇱🇰  Sri Lanka",
        "🇱🇷  Liberia",
        "🇱🇸  Lesotho",
        "🇱🇹  Lithuania",
        "🇱🇺  Luxembourg",
        "🇱🇻  Latvia",
        "🇱🇾  Libya",
        "🇲🇦  Morocco",
        "🇲🇨  Monaco",
        "🇲🇩  Moldova",
        "🇲🇪  Montenegro",
        "🇲🇫  St. Martin",
        "🇲🇬  Madagascar",
        "🇲🇭  Marshall Islands",
        "🇲🇰  North Macedonia",
        "🇲🇱  Mali",
        "🇲🇲  Myanmar (Burma)",
        "🇲🇳  Mongolia",
        "🇲🇴  Macao Sar China",
        "🇲🇵  Northern Mariana Islands",
        "🇲🇶  Martinique",
        "🇲🇷  Mauritania",
        "🇲🇸  Montserrat",
        "🇲🇹  Malta",
        "🇲🇺  Mauritius",
        "🇲🇻  Maldives",
        "🇲🇼  Malawi",
        "🇲🇽  Mexico",
        "🇲🇾  Malaysia",
        "🇲🇿  Mozambique",
        "🇳🇦  Namibia",
        "🇳🇨  New Caledonia",
        "🇳🇪  Niger",
        "🇳🇫  Norfolk Island",
        "🇳🇬  Nigeria",
        "🇳🇮  Nicaragua",
        "🇳🇱  Netherlands",
        "🇳🇴  Norway",
        "🇳🇵  Nepal",
        "🇳🇷  Nauru",
        "🇳🇺  Niue",
        "🇳🇿  New Zealand",
        "🇴🇲  Oman",
        "🇵🇦  Panama",
        "🇵🇪  Peru",
        "🇵🇫  French Polynesia",
        "🇵🇬  Papua New Guinea",
        "🇵🇭  Philippines",
        "🇵🇰  Pakistan",
        "🇵🇱  Poland",
        "🇵🇲  St. Pierre & Miquelon",
        "🇵🇳  Pitcairn Islands",
        "🇵🇷  Puerto Rico",
        "🇵🇸  Palestinian Territories",
        "🇵🇹  Portugal",
        "🇵🇼  Palau",
        "🇵🇾  Paraguay",
        "🇶🇦  Qatar",
        "🇷🇪  Réunion",
        "🇷🇴  Romania",
        "🇷🇸  Serbia",
        "🇷🇺  Russia",
        "🇷🇼  Rwanda",
        "🇸🇦  Saudi Arabia",
        "🇸🇧  Solomon Islands",
        "🇸🇨  Seychelles",
        "🇸🇩  Sudan",
        "🇸🇪  Sweden",
        "🇸🇬  Singapore",
        "🇸🇭  St. Helena",
        "🇸🇮  Slovenia",
        "🇸🇯  Svalbard & Jan Mayen",
        "🇸🇰  Slovakia",
        "🇸🇱  Sierra Leone",
        "🇸🇲  San Marino",
        "🇸🇳  Senegal",
        "🇸🇴  Somalia",
        "🇸🇷  Suriname",
        "🇸🇸  South Sudan",
        "🇸🇹  São Tomé & Príncipe",
        "🇸🇻  El Salvador",
        "🇸🇽  Sint Maarten",
        "🇸🇾  Syria",
        "🇸🇿  Eswatini",
        "🇹🇦  Tristan Da Cunha",
        "🇹🇨  Turks & Caicos Islands",
        "🇹🇩  Chad",
        "🇹🇫  French Southern Territories",
        "🇹🇬  Togo",
        "🇹🇭  Thailand",
        "🇹🇯  Tajikistan",
        "🇹🇰  Tokelau",
        "🇹🇱  Timor-Leste",
        "🇹🇲  Turkmenistan",
        "🇹🇳  Tunisia",
        "🇹🇴  Tonga",
        "🇹🇷  Turkey",
        "🇹🇹  Trinidad & Tobago",
        "🇹🇻  Tuvalu",
        "🇹🇼  Taiwan",
        "🇹🇿  Tanzania",
        "🇺🇦  Ukraine",
        "🇺🇬  Uganda",
        "🇺🇲  U.S. Outlying Islands",
        "🇺🇳  United Nations",
        "🇺🇾  Uruguay",
        "🇺🇿  Uzbekistan",
        "🇻🇦  Vatican City",
        "🇻🇨  St. Vincent & Grenadines",
        "🇻🇪  Venezuela",
        "🇻🇬  British Virgin Islands",
        "🇻🇮  U.S. Virgin Islands",
        "🇻🇳  Vietnam",
        "🇻🇺  Vanuatu",
        "🇼🇫  Wallis & Futuna",
        "🇼🇸  Samoa",
        "🇽🇰  Kosovo",
        "🇾🇪  Yemen",
        "🇾🇹  Mayotte",
        "🇿🇦  South Africa",
        "🇿🇲  Zambia",
        "🇿🇼  Zimbabwe",
        "🏴󠁧󠁢󠁥󠁮󠁧󠁿  England",
        "🏴󠁧󠁢󠁳󠁣󠁴󠁿  Scotland",
        "🏴󠁧󠁢󠁷󠁬󠁳󠁿  Wales",
        "--",
        "🇺🇸  United States",
        "🇦🇨  Ascension Island",
        "🇦🇩  Andorra",
        "🇦🇪  United Arab Emirates",
        "🇦🇫  Afghanistan",
        "🇦🇬  Antigua & Barbuda",
        "🇦🇮  Anguilla",
        "🇦🇱  Albania",
        "🇦🇲  Armenia",
        "🇦🇴  Angola",
        "🇦🇶  Antarctica",
        "🇦🇷  Argentina",
        "🇦🇸  American Samoa",
        "🇦🇹  Austria",
        "🇦🇺  Australia",
        "🇦🇼  Aruba",
        "🇦🇽  Åland Islands",
        "🇦🇿  Azerbaijan",
        "🇧🇦  Bosnia & Herzegovina",
        "🇧🇧  Barbados",
        "🇧🇩  Bangladesh",
        "🇧🇪  Belgium",
        "🇧🇫  Burkina Faso",
        "🇧🇬  Bulgaria",
        "🇧🇭  Bahrain",
        "🇧🇮  Burundi",
        "🇧🇯  Benin",
        "🇧🇱  St. Barthélemy",
        "🇧🇲  Bermuda",
        "🇧🇳  Brunei",
        "🇧🇴  Bolivia",
        "🇧🇶  Caribbean Netherlands",
        "🇧🇷  Brazil",
        "🇧🇸  Bahamas",
        "🇧🇹  Bhutan",
        "🇧🇻  Bouvet Island",
        "🇧🇼  Botswana",
        "🇧🇾  Belarus",
        "🇧🇿  Belize",
        "🇨🇦  Canada",
        "🇨🇨  Cocos (Keeling) Islands",
        "🇨🇩  Congo - Kinshasa",
        "🇨🇫  Central African Republic",
        "🇨🇬  Congo - Brazzaville",
        "🇨🇭  Switzerland",
        "🇨🇮  Côte d’Ivoire",
        "🇨🇰  Cook Islands",
        "🇨🇱  Chile",
        "🇨🇲  Cameroon",
        "🇨🇳  China",
        "🇨🇴  Colombia",
        "🇨🇵  Clipperton Island",
        "🇨🇷  Costa Rica",
        "🇨🇺  Cuba",
        "🇨🇻  Cape Verde",
        "🇨🇼  Curaçao",
        "🇨🇽  Christmas Island",
        "🇨🇾  Cyprus",
        "🇨🇿  Czechia",
        "🇩🇪  Germany",
        "🇩🇬  Diego Garcia",
        "🇩🇯  Djibouti",
        "🇩🇰  Denmark",
        "🇩🇲  Dominica",
        "🇩🇴  Dominican Republic",
        "🇩🇿  Algeria",
        "🇪🇦  Ceuta & Melilla",
        "🇪🇨  Ecuador",
        "🇪🇪  Estonia",
        "🇪🇬  Egypt",
        "🇪🇭  Western Sahara",
        "🇪🇷  Eritrea",
        "🇪🇸  Spain",
        "🇪🇹  Ethiopia",
        "🇪🇺  European Union",
        "🇫🇮  Finland",
        "🇫🇯  Fiji",
        "🇫🇰  Falkland Islands",
        "🇫🇲  Micronesia",
        "🇫🇴  Faroe Islands",
        "🇫🇷  France",
        "🇬🇦  Gabon",
        "🇬🇧  United Kingdom",
        "🇬🇩  Grenada",
        "🇬🇪  Georgia",
        "🇬🇫  French Guiana",
        "🇬🇬  Guernsey",
        "🇬🇭  Ghana",
        "🇬🇮  Gibraltar",
        "🇬🇱  Greenland",
        "🇬🇲  Gambia",
        "🇬🇳  Guinea",
        "🇬🇵  Guadeloupe",
        "🇬🇶  Equatorial Guinea",
        "🇬🇷  Greece",
        "🇬🇸  South Georgia & South Sandwich Islands",
        "🇬🇹  Guatemala",
        "🇬🇺  Guam",
        "🇬🇼  Guinea-Bissau",
        "🇬🇾  Guyana",
        "🇭🇰  Hong Kong SAR China",
        "🇭🇲  Heard & McDonald Islands",
        "🇭🇳  Honduras",
        "🇭🇷  Croatia",
        "🇭🇹  Haiti",
        "🇭🇺  Hungary",
        "🇮🇨  Canary Islands",
        "🇮🇩  Indonesia",
        "🇮🇪  Ireland",
        "🇮🇱  Israel",
        "🇮🇲  Isle of Man",
        "🇮🇳  India",
        "🇮🇴  British Indian Ocean Territory",
        "🇮🇶  Iraq",
        "🇮🇷  Iran",
        "🇮🇸  Iceland",
        "🇮🇹  Italy",
        "🇯🇪  Jersey",
        "🇯🇲  Jamaica",
        "🇯🇴  Jordan",
        "🇯🇵  Japan",
        "🇰🇪  Kenya",
        "🇰🇬  Kyrgyzstan",
        "🇰🇭  Cambodia",
        "🇰🇮  Kiribati",
        "🇰🇲  Comoros",
        "🇰🇳  St. Kitts & Nevis",
        "🇰🇵  North Korea",
        "🇰🇷  South Korea",
        "🇰🇼  Kuwait",
        "🇰🇾  Cayman Islands",
        "🇰🇿  Kazakhstan",
        "🇱🇦  Laos",
        "🇱🇧  Lebanon",
        "🇱🇨  St. Lucia",
        "🇱🇮  Liechtenstein",
        "🇱🇰  Sri Lanka",
        "🇱🇷  Liberia",
        "🇱🇸  Lesotho",
        "🇱🇹  Lithuania",
        "🇱🇺  Luxembourg",
        "🇱🇻  Latvia",
        "🇱🇾  Libya",
        "🇲🇦  Morocco",
        "🇲🇨  Monaco",
        "🇲🇩  Moldova",
        "🇲🇪  Montenegro",
        "🇲🇫  St. Martin",
        "🇲🇬  Madagascar",
        "🇲🇭  Marshall Islands",
        "🇲🇰  North Macedonia",
        "🇲🇱  Mali",
        "🇲🇲  Myanmar (Burma)",
        "🇲🇳  Mongolia",
        "🇲🇴  Macao Sar China",
        "🇲🇵  Northern Mariana Islands",
        "🇲🇶  Martinique",
        "🇲🇷  Mauritania",
        "🇲🇸  Montserrat",
        "🇲🇹  Malta",
        "🇲🇺  Mauritius",
        "🇲🇻  Maldives",
        "🇲🇼  Malawi",
        "🇲🇽  Mexico",
        "🇲🇾  Malaysia",
        "🇲🇿  Mozambique",
        "🇳🇦  Namibia",
        "🇳🇨  New Caledonia",
        "🇳🇪  Niger",
        "🇳🇫  Norfolk Island",
        "🇳🇬  Nigeria",
        "🇳🇮  Nicaragua",
        "🇳🇱  Netherlands",
        "🇳🇴  Norway",
        "🇳🇵  Nepal",
        "🇳🇷  Nauru",
        "🇳🇺  Niue",
        "🇳🇿  New Zealand",
        "🇴🇲  Oman",
        "🇵🇦  Panama",
        "🇵🇪  Peru",
        "🇵🇫  French Polynesia",
        "🇵🇬  Papua New Guinea",
        "🇵🇭  Philippines",
        "🇵🇰  Pakistan",
        "🇵🇱  Poland",
        "🇵🇲  St. Pierre & Miquelon",
        "🇵🇳  Pitcairn Islands",
        "🇵🇷  Puerto Rico",
        "🇵🇸  Palestinian Territories",
        "🇵🇹  Portugal",
        "🇵🇼  Palau",
        "🇵🇾  Paraguay",
        "🇶🇦  Qatar",
        "🇷🇪  Réunion",
        "🇷🇴  Romania",
        "🇷🇸  Serbia",
        "🇷🇺  Russia",
        "🇷🇼  Rwanda",
        "🇸🇦  Saudi Arabia",
        "🇸🇧  Solomon Islands",
        "🇸🇨  Seychelles",
        "🇸🇩  Sudan",
        "🇸🇪  Sweden",
        "🇸🇬  Singapore",
        "🇸🇭  St. Helena",
        "🇸🇮  Slovenia",
        "🇸🇯  Svalbard & Jan Mayen",
        "🇸🇰  Slovakia",
        "🇸🇱  Sierra Leone",
        "🇸🇲  San Marino",
        "🇸🇳  Senegal",
        "🇸🇴  Somalia",
        "🇸🇷  Suriname",
        "🇸🇸  South Sudan",
        "🇸🇹  São Tomé & Príncipe",
        "🇸🇻  El Salvador",
        "🇸🇽  Sint Maarten",
        "🇸🇾  Syria",
        "🇸🇿  Eswatini",
        "🇹🇦  Tristan Da Cunha",
        "🇹🇨  Turks & Caicos Islands",
        "🇹🇩  Chad",
        "🇹🇫  French Southern Territories",
        "🇹🇬  Togo",
        "🇹🇭  Thailand",
        "🇹🇯  Tajikistan",
        "🇹🇰  Tokelau",
        "🇹🇱  Timor-Leste",
        "🇹🇲  Turkmenistan",
        "🇹🇳  Tunisia",
        "🇹🇴  Tonga",
        "🇹🇷  Turkey",
        "🇹🇹  Trinidad & Tobago",
        "🇹🇻  Tuvalu",
        "🇹🇼  Taiwan",
        "🇹🇿  Tanzania",
        "🇺🇦  Ukraine",
        "🇺🇬  Uganda",
        "🇺🇲  U.S. Outlying Islands",
        "🇺🇳  United Nations",
        "🇺🇾  Uruguay",
        "🇺🇿  Uzbekistan",
        "🇻🇦  Vatican City",
        "🇻🇨  St. Vincent & Grenadines",
        "🇻🇪  Venezuela",
        "🇻🇬  British Virgin Islands",
        "🇻🇮  U.S. Virgin Islands",
        "🇻🇳  Vietnam",
        "🇻🇺  Vanuatu",
        "🇼🇫  Wallis & Futuna",
        "🇼🇸  Samoa",
        "🇽🇰  Kosovo",
        "🇾🇪  Yemen",
        "🇾🇹  Mayotte",
        "🇿🇦  South Africa",
        "🇿🇲  Zambia",
        "🇿🇼  Zimbabwe",
        "🏴󠁧󠁢󠁥󠁮󠁧󠁿  England",
        "🏴󠁧󠁢󠁳󠁣󠁴󠁿  Scotland",
        "🏴󠁧󠁢󠁷󠁬󠁳󠁿  Wales"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPicker.dataSource = self
        countryPicker.delegate = self
        // Do any additional setup after loading the view.
        selectCountry.layer.borderColor = UIColor.systemGray6.cgColor
        selectCountry.layer.cornerRadius = 5
        selectCountry.layer.borderWidth = 1
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidePicker)))
        self.countryPicker.selectRow(countryList.count / 2, inComponent: 0, animated: false)
        nextButton.layer.cornerRadius = 10
        
        
        selectCountry.titleLabel?.adjustsFontForContentSizeCategory = false
        
    }
    
    @objc private func errorVibration() {
        HapticsManager.shared.vibrate(for: .error)
    }
    
    @objc private func hidePicker() {
        if countryPicker.isHidden == false {
            countryPicker.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.nextButton.frame.origin.y += 265
                self.errorMessage.frame.origin.y += 267
            }
            
        }
        
    }
    @IBAction func selectCountrySelected(_ sender: Any) {
        if countryPicker.isHidden {
            UIView.animate(withDuration: 0.3) {
                self.nextButton.frame.origin.y -= 265
                self.errorMessage.frame.origin.y -= 267
            }
            animate(toggle: true)
            
            
            
        } else {
            
            animate(toggle: false)
            UIView.animate(withDuration: 0.3) {
                self.nextButton.frame.origin.y += 265
                self.errorMessage.frame.origin.y += 267
            }
            
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if selectCountry.titleLabel!.text == "Select Country" || selectCountry.titleLabel!.text == "--" {
            errorMessage.isHidden = false
            
            errorVibration()
        }
        else {
            var fixedCountry = selectCountry.titleLabel?.text
            fixedCountry!.removeFirst()
            fixedCountry!.removeFirst()
            fixedCountry!.removeFirst()
            sharedCountry = fixedCountry!
            errorMessage.isHidden = true
            performSegue(withIdentifier: "fromCountrySegue", sender: self)
        }
    }
    
    
    func animate(toggle: Bool) {
        if toggle {
            UIView.animate(withDuration: 0.3) {
                self.countryPicker.isHidden = false
            }
        }
        else {
            UIView.animate(withDuration: 0.3) {
                self.countryPicker.isHidden = true
            }
        }
    }
    
}
// MARK: - Select Country PickerView 
extension EnterInformationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCountry.setTitle("\(countryList[row])", for: .normal)
        
    }
    
}

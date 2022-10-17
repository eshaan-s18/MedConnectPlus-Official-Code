//
//  YourInformationViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/3/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import MessageUI

var deletedUser = false


class YourInformationViewController: UIViewController {
    
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var userIDTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var birthdayButton: UIButton!
    
    @IBOutlet weak var countryButton: UIButton!
    
    @IBOutlet weak var raceButton: UIButton!
    
    @IBOutlet weak var genderButton: UIButton!
    
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var editOriginalButton: UIBarButtonItem!
    
    @IBOutlet weak var doneOriginalButton: UIBarButtonItem!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var countryPicker: UIPickerView!
    
    @IBOutlet weak var racePicker: UIPickerView!
    
    @IBOutlet weak var genderPicker: UIPickerView!
    
    
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    
    var savedEmail = ""
    var savedCountry = ""
    var savedBirthday = ""
    var savedGender = ""
    var savedRace = ""
    
    var db = Firestore.firestore()
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    var appliedList = ["test"]
    
    var selectedOption = ""
    
    var genderList = [
        "Female",
        "Male",
        "Other",
    ]
    
    var raceList = [
        "White",
        "Black or African American",
        "American Indian or Alaska Native",
        "Asian",
        "Native Hawaiian or Other Pacific Islander",
    ]
    
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
        "Other",
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
        "Other"
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loading.hidesWhenStopped = true
        loading.startAnimating()
        
        deleteButton.layer.cornerRadius = 25
        
        loadInformationData()
        
        logOutButton.layer.cornerRadius = 25
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//            self.loading.stopAnimating()
//        }
        
        datePicker.backgroundColor = UIColor.systemGray6
        

        datePicker.addTarget(self, action: #selector(datePickerValueChange(sender:)), for: UIControl.Event.valueChanged)

        countryPicker.tag = 1
        racePicker.tag = 2
        genderPicker.tag = 3
        countryPicker.delegate = self
        countryPicker.dataSource = self
        racePicker.delegate = self
        racePicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.dataSource = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideOtherPicker)))
//        UIButton.appearance().adjustsImageSizeForAccessibilityContentSizeCategory = false
        self.countryPicker.selectRow(countryList.count / 2, inComponent: 0, animated: false)
        self.racePicker.selectRow(raceList.count / 2, inComponent: 0, animated: false)
        self.genderPicker.selectRow(genderList.count / 2, inComponent: 0, animated: false)
        
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        datePicker.maximumDate = currentDate
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidePicker)))
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        borderView.backgroundColor = UIColor.white
        borderView.layer.borderColor = UIColor.white.cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 10
             // Do any additional setup after loading the view.
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        
        

       
    }
    
    
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        handleSignOut()
    }
    
    @IBAction func reportABugTapped(_ sender: Any) {
    }
    
    @IBAction func contactUsButtonTapped(_ sender: Any) {
        showMailComposer()
        
    }
    
    
    func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["contact.medconnect@gmail.com"])
        composer.setSubject("MedConnect App Support")
        composer.setMessageBody("Please describe your reason to contact MedConnect support:\n--> ", isHTML: false)
        
        present(composer, animated: true)
        
    }
    
    @IBAction func privacyButtonTapped(_ sender: Any) {
        var privacyPolicyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrivacyPolicyViewController")
        if let sheet = privacyPolicyVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 10
            
        }

        self.present(privacyPolicyVC, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        emailTextField.text = savedEmail
        
        let alert = UIAlertController(title: "Confirm Delete Account", message: "Please type in your password to confirm your account delete.", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "Delete", style: .default) { (alertAction) in
                let textField = alert.textFields![0] as UITextField
                FirebaseAuth.Auth.auth().signIn(withEmail: self.savedEmail, password: textField.text!, completion: { [weak self] result, error in
                    guard let strongSelf = self else {
                        return
                    }
                    guard error == nil else {
                        self!.errorVibration()
                        let alert = Service.createAlertController(title: "Error - Failed Account Delete", message: "Password incorrect. Account delete failed.")
                        self!.present(alert, animated: true, completion: nil)
                        print("error")
                        
                        
                        return
                    }
                    print("Signed In")
                    
                    print(Auth.auth().currentUser!.uid)
                    
                    
                    let credential = EmailAuthProvider.credential(withEmail: self!.savedEmail, password: textField.text!)
                    Auth.auth().currentUser?.reauthenticate(with: credential)
                    
                    let user = Auth.auth().currentUser
                    
                    deletedUser = true
                    print(deletedUser)

                    self!.db.collection("Users").document(Auth.auth().currentUser!.uid).delete()
                    
                   // self!.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(["deleted": "True"])
                    
                    self!.performSegue(withIdentifier: "toLoginPageSegue", sender: self)

                    
                    
                   // self!.signOut()
                    
                    

                    
                    
                })
            }
            alert.addTextField { (textField) in
                textField.placeholder = "Enter your password"
                textField.isSecureTextEntry = true
                
            }
            alert.addAction(action)
            self.present(alert, animated:true, completion: nil)
        }
    
    
        
        
        
        
        
        
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toLoginPageSegue" {
//            let fullScreenViewController = segue.destination
//            fullScreenViewController.modalPresentationStyle = UIModalPresentationStyle.automatic
//            fullScreenViewController.activePresentationController!.delegate = self
//        }
    }
    
    func deleteAccount() {
        
        do {
            
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toLoginPageSegue", sender: self)
        } catch let error {
            let alert = Service.createAlertController(title: "Error", message: error.localizedDescription)
            self.present(alert, animated: true, completion: nil)
            
        
        }
        
        

    }
    
    
    
    
    
    @objc func handleSignOut() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toLoginPageSegue", sender: self)
        } catch let error {
            let alert = Service.createAlertController(title: "Error", message: error.localizedDescription)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
    
    @objc private func errorVibration() {
        HapticsManager.shared.vibrate(for: .error)
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
      
      var returnValue = true
      let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
      
      do {
          let regex = try NSRegularExpression(pattern: emailRegEx)
          let nsString = emailAddressString as NSString
          let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
          
          if results.count == 0
          {
              returnValue = false
          }
          
      } catch let error as NSError {
          print("invalid regex: \(error.localizedDescription)")
          returnValue = false
      }
      
      return  returnValue
  }

    @objc private func hidePicker() {
        if datePicker.isHidden == false {
            datePicker.isHidden = true
            UIView.animate(withDuration: 0.3) {

            }}
        else {
            print("no")
        }

        }

    @objc private func hideOtherPicker() {
        if countryPicker.isHidden == false {
            countryPicker.isHidden = true
            UIView.animate(withDuration: 0.3) {
            }

        }
        else if racePicker.isHidden == false {
            racePicker.isHidden = true
            UIView.animate(withDuration: 0.3) {
            }
        }
        else if genderPicker.isHidden == false {
            genderPicker.isHidden = true
            UIView.animate(withDuration: 0.3) {
            }
        }
        else {
            print("no")
        }
    }
    @objc func datePickerValueChange(sender: UIDatePicker) {
        birthdayButton.setTitle("\(formatDate(date: datePicker.date))", for: .normal)
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    


    @IBAction func doneTapped(_ sender: Any) {
        if doneOriginalButton.title == "Done" {
            self.dismiss(animated: true, completion: nil)
        }

        else if doneOriginalButton.title == "Cancel" {
            editOriginalButton.title = "Edit"
            doneOriginalButton.title = "Done"
            emailTextField.text = savedEmail
            birthdayButton.setTitle(savedBirthday, for: .normal)
            genderButton.setTitle(savedGender, for: .normal)
            raceButton.setTitle(savedRace, for: .normal)
            countryButton.setTitle(savedCountry, for: .normal)
            hideKeyboard()
            datePicker.isHidden = true
            countryPicker.isHidden = true
            genderPicker.isHidden = true
            racePicker.isHidden = true
            emailTextField.textColor = UIColor.darkGray
            emailTextField.isEnabled = false
            birthdayButton.setTitleColor(UIColor.darkGray, for: .normal)
            birthdayButton.isEnabled = false
            genderButton.setTitleColor(UIColor.darkGray, for: .normal)
            genderButton.isEnabled = false
            raceButton.setTitleColor(UIColor.darkGray, for: .normal)
            raceButton.isEnabled = false
            countryButton.setTitleColor(UIColor.darkGray, for: .normal)
            countryButton.isEnabled = false
            
        }

    }

    @IBAction func editTapped(_ sender: Any) {

        if editOriginalButton.title == "Edit" {
            editOriginalButton.title = "Done"
            doneOriginalButton.title = "Cancel"
            emailTextField.textColor = UIColor.systemBlue
            emailTextField.isEnabled = true
            birthdayButton.setTitleColor(UIColor.systemBlue, for: .normal)
            birthdayButton.isEnabled = true
            genderButton.setTitleColor(UIColor.systemBlue, for: .normal)
            genderButton.isEnabled = true
            raceButton.setTitleColor(UIColor.systemBlue, for: .normal)
            raceButton.isEnabled = true
            countryButton.setTitleColor(UIColor.systemBlue, for: .normal)
            countryButton.isEnabled = true
        }

        else if editOriginalButton.title == "Done" {
            editOriginalButton.title = "Edit"
            doneOriginalButton.title = "Done"
            datePicker.isHidden = true
            countryPicker.isHidden = true
            racePicker.isHidden = true
            genderPicker.isHidden = true
            emailTextField.textColor = UIColor.darkGray
            emailTextField.isEnabled = false
            print(savedEmail)
            if emailTextField.text != savedEmail {
                if isValidEmailAddress(emailAddressString: emailTextField.text!){
                    let alert = UIAlertController(title: "User Reauthentication", message: "Please type in your password to change your email login.", preferredStyle: UIAlertController.Style.alert)
                    let action = UIAlertAction(title: "Done", style: .default) { (alertAction) in
                        let textField = alert.textFields![0] as UITextField
                        FirebaseAuth.Auth.auth().signIn(withEmail: self.savedEmail, password: textField.text!, completion: { [weak self] result, error in
                            guard let strongSelf = self else {
                                return
                            }
                            guard error == nil else {
                                self!.errorVibration()
                                self!.emailTextField.text = self!.savedEmail
                                let alert = Service.createAlertController(title: "Error", message: "Password incorrect. Reauthentication failed. Email not changed.")
                                self!.present(alert, animated: true, completion: nil)
                                print("error")
                                self!.emailTextField.textColor = UIColor.darkGray
                                self!.emailTextField.isEnabled = false
                                
                                return
                            }
                            print("Signed In")
                            
                            let credential = EmailAuthProvider.credential(withEmail: self!.savedEmail, password: textField.text!)
                            Auth.auth().currentUser?.reauthenticate(with: credential)
                            Auth.auth().currentUser?.updateEmail(to: self!.emailTextField.text!)
                            self!.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData(["email" : self!.emailTextField.text])
                            self!.savedEmail = self!.emailTextField.text!
                            self!.emailTextField.textColor = UIColor.darkGray
                            self!.emailTextField.isEnabled = false
                        })
                    }
                    alert.addTextField { (textField) in
                        textField.placeholder = "Enter your password"
                        textField.isSecureTextEntry = true
                        
                    }
                    alert.addAction(action)
                    self.present(alert, animated:true, completion: nil)
                    }
                else {
                    let alert = Service.createAlertController(title: "Error", message: "Invalid email. Email not changed.")
                    self.present(alert, animated: true, completion: nil)
                    self.errorVibration()
                    self.emailTextField.text = self.savedEmail
                    self.emailTextField.textColor = UIColor.darkGray
                    self.emailTextField.isEnabled = false
                    
                }
            }
                
            
            birthdayButton.setTitleColor(UIColor.darkGray, for: .normal)
            birthdayButton.isEnabled = false
            db.collection("Users").document(Auth.auth().currentUser!.uid).updateData(["birthday" : birthdayButton.titleLabel?.text])
            savedBirthday = (birthdayButton.titleLabel?.text)!
            genderButton.setTitleColor(UIColor.darkGray, for: .normal)
            genderButton.isEnabled = false
            db.collection("Users").document(Auth.auth().currentUser!.uid).updateData(["gender" : genderButton.titleLabel?.text])
            savedGender = (genderButton.titleLabel?.text)!
            raceButton.setTitleColor(UIColor.darkGray, for: .normal)
            raceButton.isEnabled = false
            db.collection("Users").document(Auth.auth().currentUser!.uid).updateData(["race" : raceButton.titleLabel?.text])
            savedRace = (raceButton.titleLabel?.text)!
            countryButton.setTitleColor(UIColor.darkGray, for: .normal)
            countryButton.isEnabled = false
            db.collection("Users").document(Auth.auth().currentUser!.uid).updateData(["country" : countryButton.titleLabel?.text])
            savedCountry = (countryButton.titleLabel?.text)!
            print(savedCountry)
        }
    }
    
    
    @IBAction func textFieldTapped(_ sender: Any) {
        print("Testig")
        countryPicker.isHidden = true
        genderPicker.isHidden = true
        racePicker.isHidden = true
        datePicker.isHidden = true
    }
    
    

    @IBAction func birthdayTapped(_ sender: Any) {
        countryPicker.isHidden = true
        genderPicker.isHidden = true
        racePicker.isHidden = true
        hideKeyboard()
        if datePicker.isHidden == true {
            datePicker.isHidden = false
        }
        else {
            datePicker.isHidden = true
        }
    }

    @IBAction func countryTapped(_ sender: Any) {
        genderPicker.isHidden = true
        racePicker.isHidden = true
        datePicker.isHidden = true
        hideKeyboard()
        if countryPicker.isHidden == true {
            countryPicker.isHidden = false
        }
        else {
            countryPicker.isHidden = true
        }
    }

    @IBAction func raceTapped(_ sender: Any) {
        
        genderPicker.isHidden = true
        countryPicker.isHidden = true
        datePicker.isHidden = true
        hideKeyboard()
        if racePicker.isHidden == true {
            racePicker.isHidden = false
        }
        else {
            racePicker.isHidden = true
        }
    }

    @IBAction func genderTapped(_ sender: Any) {
        racePicker.isHidden = true
        countryPicker.isHidden = true
        print(appliedList)
        datePicker.isHidden = true
        hideKeyboard()
        if genderPicker.isHidden == true {
            genderPicker.isHidden = false
        }
        else {
            genderPicker.isHidden = true
        }

    }


    func loadInformationData() {
        
        let docRefOne = db.collection("Users").document(Auth.auth().currentUser!.uid)

        docRefOne.getDocument { (document, error) in

            let result = Result {
              try document?.data(as: EmailReference.self)

            }
            print(result)
            switch result {
            case .success(let email):
                if let email = email {
                    // A `City` value was successfully initialized from the DocumentSnapshot.
                    self.emailTextField.text = email.email
                    self.savedEmail = email.email!
                    //self.questionLabel.text = question.question
                    print("okay")
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
                print("Error decoding question: \(error)")
                }
            }

        let docRefTwo = db.collection("Users").document(Auth.auth().currentUser!.uid)

        docRefTwo.getDocument { (document, error) in

            let result = Result {
              try document?.data(as: UIDReference.self)

            }
            print(result)
            switch result {
            case .success(let userID):
                if let userID = userID {
                    // A `City` value was successfully initialized from the DocumentSnapshot.
                    self.userIDTextField.text = userID.userID
                    //self.questionLabel.text = question.question
                    print("okay")
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
                print("Error decoding question: \(error)")
                }
            }

        let docRefThree = db.collection("Users").document(Auth.auth().currentUser!.uid)

        docRefThree.getDocument { [self] (document, error) in

            let result = Result {
              try document?.data(as: BirthdayReference.self)

            }
            print(result)
            switch result {
            case .success(let birthday):
                if let birthday = birthday {
                    // A `City` value was successfully initialized from the DocumentSnapshot.
                    self.birthdayButton.setTitle(birthday.birthday, for: .normal)
                    self.savedBirthday = birthday.birthday!
                    //self.questionLabel.text = question.question
                    print("okay")
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
                print("Error decoding question: \(error)")
                }
            }

        let docRefFour = db.collection("Users").document(Auth.auth().currentUser!.uid)

        docRefFour.getDocument { (document, error) in

            let result = Result {
              try document?.data(as: CountryReference.self)

            }
            print(result)
            switch result {
            case .success(let country):
                if let country = country {
                    // A `City` value was successfully initialized from the DocumentSnapshot.
                    self.countryButton.setTitle(country.country, for: .normal)
                    self.savedCountry = country.country!
                    //self.questionLabel.text = question.question
                    print("okay")
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
                print("Error decoding question: \(error)")
                }
            }

        let docRefFive = db.collection("Users").document(Auth.auth().currentUser!.uid)

        docRefFive.getDocument { (document, error) in

            let result = Result {
              try document?.data(as: RaceReference.self)

            }
            print(result)
            switch result {
            case .success(let race):
                if let race = race {
                    // A `City` value was successfully initialized from the DocumentSnapshot.
                    self.raceButton.setTitle(race.race, for: .normal)
                    self.savedRace = race.race!
                    //self.questionLabel.text = question.question
                    print("okay")
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
                print("Error decoding question: \(error)")
                }
            }


            let docRefSix = db.collection("Users").document(Auth.auth().currentUser!.uid)

                docRefSix.getDocument { (document, error) in

                let result = Result {
                  try document?.data(as: GenderReference.self)

                }
                print(result)
                switch result {
                case .success(let gender):
                    if let gender = gender {
                        // A `City` value was successfully initialized from the DocumentSnapshot.
                        self.genderButton.setTitle(gender.gender, for: .normal)
                        self.savedGender = gender.gender!
                        
                        self.loading.stopAnimating()


                        //self.questionLabel.text = question.question
                        print("okay")
                    } else {
                        // A nil value was successfully initialized from the DocumentSnapshot,
                        // or the DocumentSnapshot was nil.
                        print("Document does not exist")
                    }
                case .failure(let error):
                    // A `City` value could not be initialized from the DocumentSnapshot.
                    print("Error decoding question: \(error)")
                    }
                }
            
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

extension YourInformationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return countryList.count
        case 2:
            return raceList.count
        case 3:
            return genderList.count
        default:
            return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return countryList[row]
        case 2:
            return raceList[row]
        case 3:
            return genderList[row]
        default:
            return "Data not found"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
 
        switch pickerView.tag {
        case 1:
            var newCountry = countryList[row]
            newCountry.removeFirst()
            newCountry.removeFirst()
            newCountry.removeFirst()
            
             countryButton.setTitle("\(newCountry)", for: .normal)
        case 2:
            raceButton.setTitle("\(raceList[row])", for: .normal)
        case 3:

            genderButton.setTitle("\(genderList[row])", for: .normal)
        default:
            print("Data not found")
        }



    }

}

extension YourInformationViewController:MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
            controller.dismiss(animated: true)

        case .failed:
            let alert = UIAlertController(title: "Error", message: "Failed support email send. Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    controller.dismiss(animated: true)

                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                }
            }))
            controller.dismiss(animated: true)

            self.present(alert, animated: true, completion: nil)
        case .saved:
            print("Saved")
            controller.dismiss(animated: true)

        case .sent:
            let alert = UIAlertController(title: "Support Email Sent", message: "Please give our team a couple days to get back to you", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    print("default")

                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                }
            }))
            
            controller.dismiss(animated: true)

            self.present(alert, animated: true, completion: nil)
            

        }

    }
}

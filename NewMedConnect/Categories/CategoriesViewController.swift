//
//  CategoriesViewController.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/8/22.
//

import UIKit
import SwiftUI
import FirebaseAuth
import CloudKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseFirestore

var conditionsNames = [String]()
var categorySelected = ""

// MARK: - Communities Page
// Changed from Categories to Communities
// Favorites changed to Pinned
class CategoriesViewController: UIViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    
    @IBOutlet weak var sendRequestButton: UIButton!
    
    @IBOutlet weak var sendRequestMessage: UILabel!
    
    @IBOutlet weak var noPinnedMessage: UILabel!
    
    var favorites = [""]
    var pinnedInitializer = 0
    
    let db = Firestore.firestore()
    
    var conditionsData = [Condition]()
    
    var categories = ["Blood and Lymph",
                      "Brain, Nerves, and Spinal Cord",
                      "Cancer",
                      "Chromosomal Conditions",
                      "Diabetes",
                      "Ears, Nose, and Throat",
                      "Eyes",
                      "Glands",
                      "Heart and Blood Vessels",
                      "Immune System",
                      "Infections and Poisoning",
                      "Injuries",
                      "Kidneys, Bladder, and Prostate",
                      "Lungs and Airways",
                      "Mental Health",
                      "Mouth",
                      "Muscle, Bone, and Joints",
                      "Nutritional",
                      "Pregnancy and Childbirth",
                      "Sexual and Reproductive",
                      "Skin, Hair, and Nails",
                      "Stomach, Liver, and Gastrointestinal Tract"]
    
    var bloodAndLymphConditions = ["Acute Lymphoblastic Leukemia", "Acute Myeloid Leukemia", "Chronic Lymphocytic Leukemia", "Chronic Myeloid Leukemia", "Deep Vein Thrombosis", "Hairy Cell Leukemia", "High Blood Pressure (Hypertension)", "High Cholesterol", "Hodgkin Lymphoma", "Hyperglycaemia (High Blood Sugar)", "Hypoglycaemia (Low Blood Sugar)", "Low Blood Pressure (Hypotension)", "Lymphoedema", "Non-Hodgkin Lymphoma", "Sepsis", "Septic Shock", "Sickle Cell Disease"]
    
    var brainNervesSpinalConditions = ["Alzheimer's Disease", "Autism Spectrum Disorder (ASD)", "Brain Stem Death", "Chronic Pain", "Coma", "Dementia", "Dementia with Lewy Bodies", "Dizziness (lightheadedness)", "Epilepsy", "Febrile Seizures", "Headaches", "Huntington's Disease", "Migraine", "Motor Neurone Disease (MND)", "Multiple Sclerosis (MS)", "Myalgic Encephalomyelitis (ME) and Chronic Fatigue Syndrome (CFS)", "Parkinson's Disease", "Peripheral Neuropathy", "Restless Legs Syndrome", "Stroke", "Tay-Sachs Disease", "Trasient Ischaemic Attack (TIA)", "Trigeminal Neuralgia"]
    
    var cancerConditions = ["Acute Lymphoblastic Leukemia", "Acute Myeloid Leukemia", "Anal Cancer", "Bile Duct Cancer (Cholangiocarcinoma)", "Bladder Cancer", "Bone Cancer", "Bowel Cancer", "Brain Tumors", "Breast Cancer (Female)", "Breast Cancer (Male)", "Carcinoid Syndrome and Carcinoid Tumors", "Cervical Cancer", "Chronic Lymphocytic Leukemia", "Chronic Myeloid Leukemia", "Ewing Sarcoma", "Eye Cancer", "Gallbladder Cancer", "Germ Cell Tumors", "Hairy Cell Leukemia", "Head and Neck Cancer", "Hodgkin Lymphoma", "Kaposi's Sarcoma", "Kidney Cancer", "Laryngeal (Larynx) Cancer", "Liver Cancer", "Lung Cancer", "Malignant Brain Tumor (Cancerous)", "Mesothelioma", "Mouth Cancer", "Multiple Myeloma", "Nasal and Sinus Cancer", "Nasopharyngeal Cancer", "Neuroblastoma", "Neuroendocrine Tumors", "Non-Hodgkin Lymphoma", "Oesophageal Cancer", "Osteosarcoma", "Ovarian Cancer", "Paget's Disease of the Nipple", "Pancreatic Cancer", "Penile Cancer", "Prostate Cancer", "Retinoblastoma", "Rhabdomyosarcoma", "Skin Cancer (Melanoma)", "Skin Cancer (Non-Melanoma)", "Soft Tissue Sarcomas", "Stomach Cancer", "Testicular Cancer", "Thyroid Cancer", "Vaginal Cancer", "Vulval Cancer", "Wilms' Tumor", "Womb (Uterus) Cancer"]
    
    var chromosomalConditions = ["Down's Syndrome", "Edwards' Syndrome", "Patau's Syndrome", "Turner Syndrome"]
    
    var diabetesConditions = ["Diabetes", "Diabetic Retinopathy", "Type 1 Diabetes", "Type 2 Diabetes"]
    
    var earsNoseThroatConditions = ["Allergic Rhinitis", "Earache", "Earwax Build-Up", "Feeling of Something in Your Throat (Globus)", "Hearing Loss", "Labyrinthitis", "Laryngitis", "Middle Ear Infection (Otitis Media)", "Meniere's Disease", "Nosebleed", "Otitis Externa", "Sinusitis", "Sore Throat", "Tinnitus", "Tonsillitis", "Vertigo"]
    
    var eyesConditions = ["Conjunctivitis", "Deafblindness", "Eye Cancer", "Diabetic Retinopathy", "Standard Eye Care"]
    
    var glandsConditions = ["Addison's Disease", "Overactive Thyroid", "Swollen Glands", "Underactive Thyroid"]
    
    var heartBloodVesselsConditions = ["Abdominal Aortic Aneurysm", "Angina", "Arterial Thrombosis", "Atrial Fibrillation", "Cardiovascular Disease", "Chest Pain", "Congenital Heart Disease", "Coronary Heart Disease", "Heart Attack", "Heart Block", "Heart Failure", "Heart Palpitations", "High Blood Pressure (Hypertension)", "Inherited Heart Conditions", "Low Blood Pressure (Hypotension)", "Pulmonary Hypertension", "Raynaud's Phenomenon", "Supraventricular Tachycardia", "Varicose Veins", "Wolff-Parkinson-White Syndrome"]
    
    var immuneSystemConditions = ["Allergies", "Anaphylaxis", "Hay Fever", "HIV", "Lupus", "Polio", "Sjogren's Syndrome"]
    
    var infectionsPoisoningConditions = ["Chest Infection", "Chickenpox", "Clostridium Difficile", "Common Cold", "Coronavirus (COVID-19)", "Ebola Virus Disease", "Escherichia Coli (E. Coli) O157", "Fever", "Flu", "Food Poisoning", "Glandular Fever", "Haemophilus Influenzae Type B (HIB)", "Hand, Foot, and Mouth Disease", "Impetigo", "Lead Poisoning", "Lyme Disease", "Malaria", "Measles", "Meningitis", "Monkeypox", "Mumps", "Norovirus", "Oral Thrush", "Pneumococcal Infections", "Polio", "Ringworm and Other Fungal Infections", "Rubella", "Scarlet Fever", "Shingles", "Slapped Cheek Syndrome", "Tetanus", "Thrush", "Tuberculosis (TB)", "Whooping Cough", "Yellow Fever", "Zika Virus"]
    
    var injuriesConditions = ["Animal and Human Bites", "Blisters", "Broken or Knocked-Out Tooth", "Burns and Scalds", "Concussion", "Cuts and Grazes", "Insect Bites and Stings", "Major Head Injury", "Minor Head Injury", "Skin Rashes", "Sunburn", "Acid and Chemical Burns", "Tick Bites"]
    
    var kidneysBladderProstateConditions = ["Benign Prostate Enlargement", "Chronic Kidney Disease", "Cystitis", "Kidney Infection", "Kidney Stones", "Urinary Incontinence", "Urinary Tract Infection (UTI)"]
    
    var lungsAirwaysConditions = ["Asbestosis", "Asthma", "Bronchiectasis", "Bronchitis", "Catarrh", "Chronic Obstructive Pulmonary Disease (COPD)", "Cough", "Croup", "Cystic Fibrosis", "Idiopathic Pulmonary Fibrosis (IPF)", "Obstructive Sleep Apnoea (OBA)", "Pleurisy", "Pneumonia", "Shortness of Breath"]
    
    var mentalHealthConditions = ["Anorexia Nervosa", "Anxiety", "Attention Deficit Hyperactivity Disorder (ADHD)", "Bipolar Disorder", "Bulimia", "Depression", "Eating Disorders", "Insomnia", "Munchausen's Syndrome", "Obsessive Compulsive Disorder (OCD)", "Panic Disorder", "Personality Disorder", "Phobias", "Post-Birth Mental Health Problems", "Post-Traumatic Stress Disorder (PTSD)", "Postnatal Depression", "Psychosis", "Schizophrenia", "Seasonal Affective Disorder (SAD)", "Self-Harm", "Suicide and Support"]
    
    var mouthConditions = ["Cold Sore", "Dental Abscess", "Dry Mouth", "Gum Disease", "Mouth Ulcer", "Tooth Decay", "Toothache"]
    
    var muscleBoneJointsConditions = ["Ankylosing Spondylitis", "Arthritis", "Bunion (Hallux Valgus)", "Carpal Tunnel Syndrome", "Cervical Spondylosis", "Chronic Pain", "Costochondritis", "Dystonia", "Fibromyalgia", "Frozen Shoulder", "Ganglion Cyst", "Gout", "Heel Pain", "Irritable Hip", "Joint Hypermobility", "Leg Cramps", "Metatarsalgia", "Osteoarthritis", "Osteoporosis", "Polymyalgia Rheumatica", "Psoriatic Arthritis", "Reactive Arthritis", "Rheumatoid Arthritis", "Scoliosis", "Ankle Problems", "Back Problems", "Calf Problems", "Elbow Problems", "Foot Problems", "Fracture Leaflets", "Hip Problems", "Knee Problems", "Neck Problems", "Shoulder Problems", "Thigh Problems", "Wrist, Hand, and Finger Problems", "Soft Tissue Injury Advice"]
    
    var nutritionalConditions = ["Dehydration", "Iron Deficiency Anaemia", "Malnutrition", "Obesity", "Thirst", "Vitamin B12 or Folate Deficiency Anaemia", "Lactose Intolerance", "Food Allergy", "Food Poisoning"]
    
    var pregnancyChildbirthConditions = ["Common Pregnancy Problems", "Health Conditions Before Pregnancy", "Health Conditions That Develop During Pregnancy", "Stillbirth", "Miscarriage", "Ectopic Pregnancy"]
    
    var sexualReproductiveConditions = ["Bacterial Vaginosis", "Chlamydia", "Erectile Dysfunction (Impotence)", "Genital Herpes", "Genital Warts", "Gonorrhoea", "HIV", "Loss of Libido", "Lymphogranuloma Venereum (LGV)", "Ovarian Cyst", "Pelvic Inflammatory Disease", "Pelvic Organ Prolapse", "Pubic Lice", "Syphilis", "Testicular Lumps and Swellings", "Thrush", "Trichomonas Infection", "Women's Health"]
    
    var skinHairNailsConditions = ["Acne", "Angioedema", "Atopic Eczema", "Cellulitis", "Chilblains", "Dermatitis Herpetiformis", "Discoid Eczema", "Fungal Nail Infection", "Head Lice and Nits", "Hyperhidrosis", "Ingrown Toenail", "Itching", "Itchy Bottom", "Lichen Planus", "Pressure Ulcers", "Psoriasis", "Psoriatic Arthritis", "Rosacea", "Scabies", "Skin Rashes", "Urticaria (Hives)", "Varicose Eczema", "Venous Leg Ulcer", "Warts and Verrucas"]
    
    var stomachLiverGastrointestinalConditions = ["Acute Cholecystitis", "Acute Pancreatitis", "Alcohol-Related Liver Disease", "Appendicitis", "Bowel Incontinence", "Bowel Polyps", "Chronic Pancreatitis", "Cirrhosis", "Coeliac Disease", "Constipation", "Crohn's Disease", "Diarrhoea", "Diverticular Disease and Diverticulitis", "Dysphagia (Swallowing Problems)", "Flatulence", "Food Poisoning", "Gallstones", "Gastro-Oesophageal Reflux Disease (GORD)", "Gastroenteritis", "Haemorrhoids (Piles)", "Hepatitis A", "Hepatitis B", "Hapetitis C", "Hiatus Hernia", "Indigestion", "Irritable Bowel Syndrome (IBS)", "Liver Disease", "Non-alcoholic Fatty Liver Disease (NAFLD)", "Spleen Problems and Spleen Removal", "Stomach Ache and Abdominal Pain", "Stomach Ulcer", "Threadworms", "Ulcerative Colitis", "Vomiting"]
    
    
    var combinedList = [String]()
    var alphSortedList = [String]()
    var searchList = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Communities"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor.systemGray6
        
        loading.startAnimating()
        loading.hidesWhenStopped = true
        
        let docRef = db.collection("Users").document(Auth.auth().currentUser!.uid)
        
        docRef.getDocument { (document, error) in
            
            let result = Result {
                try document?.data(as: PinnedReference.self)
                
            }
            print(result)
            switch result {
            case .success(let pinned):
                if let pinned = pinned {
                    self.favorites = pinned.pinned!
                    self.reload()
                    self.loading.stopAnimating()

                    
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding question: \(error)")
            }
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundImage = UIImage()

        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        
        sendRequestButton.layer.cornerRadius = 10
        
        searchBar.delegate = self
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        combinedList.append(contentsOf: bloodAndLymphConditions)
        combinedList.append(contentsOf: brainNervesSpinalConditions)
        combinedList.append(contentsOf: cancerConditions)
        combinedList.append(contentsOf: chromosomalConditions)
        combinedList.append(contentsOf: diabetesConditions)
        combinedList.append(contentsOf: earsNoseThroatConditions)
        combinedList.append(contentsOf: eyesConditions)
        combinedList.append(contentsOf: glandsConditions)
        combinedList.append(contentsOf: heartBloodVesselsConditions)
        combinedList.append(contentsOf: immuneSystemConditions)
        combinedList.append(contentsOf: infectionsPoisoningConditions)
        combinedList.append(contentsOf: injuriesConditions)
        combinedList.append(contentsOf: kidneysBladderProstateConditions)
        combinedList.append(contentsOf: lungsAirwaysConditions)
        combinedList.append(contentsOf: mentalHealthConditions)
        combinedList.append(contentsOf: mouthConditions)
        combinedList.append(contentsOf: muscleBoneJointsConditions)
        combinedList.append(contentsOf: nutritionalConditions)
        combinedList.append(contentsOf: pregnancyChildbirthConditions)
        combinedList.append(contentsOf: sexualReproductiveConditions)
        combinedList.append(contentsOf: skinHairNailsConditions)
        combinedList.append(contentsOf: stomachLiverGastrointestinalConditions)
        
        alphSortedList = combinedList.sorted(by: {$0 < $1})
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        
        navigationItem.backButtonDisplayMode = .minimal
        
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        
        favoritesTableView.layer.cornerRadius = 10
        categoriesTableView.layer.cornerRadius = 10
        
        self.favoritesTableView.reloadData()
        
        let docRef = db.collection("Users").document(Auth.auth().currentUser!.uid)
        
        docRef.getDocument { (document, error) in
            
            let result = Result {
                try document?.data(as: PinnedReference.self)
                
            }
            print(result)
            switch result {
            case .success(let pinned):
                if let pinned = pinned {
                    self.favorites = pinned.pinned!
                    self.reload()
                    self.loading.stopAnimating()
                    //self.questionLabel.text = question.question
                    print("okay")
                    
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding question: \(error)")
            }
        }
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.favoritesTableView.reloadData()
    }
    
    @objc func reload() {
        if pinnedInitializer < 1 {
            self.favoritesTableView.reloadData()
            pinnedInitializer = pinnedInitializer + 1
        }
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func sendRequestButtonTapped(_ sender: Any) {
        
        var reportResponseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestConditionViewController")
        if let sheet = reportResponseVC.sheetPresentationController {
            sheet.detents = [.large()]
        }
        
        self.present(reportResponseVC, animated: true, completion: nil)
        
    }
    
    
}

// MARK: - Pinned TableView and Groups TableView Setup
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case favoritesTableView:
            numberOfRow = favorites.count - 1
            
            if self.favorites.count == 1 {
                self.noPinnedMessage.isHidden = false
            }
            else {
                self.noPinnedMessage.isHidden = true
            }
            
        case categoriesTableView:
            numberOfRow = categories.count
        default:
            print("error")
            
        }
        return numberOfRow
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case favoritesTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath) as! PinnedTableViewCell
            cell.pinnedTitle.numberOfLines = 2
            cell.pinnedTitle.font = UIFont(name: "Manrope", size: 18)!
            cell.pinnedTitle.text = favorites[indexPath.row + 1]
            
            return cell
        case categoriesTableView:
            var cell = UITableViewCell()
            cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = categories[indexPath.row]
            content.textProperties.font = UIFont(name: "Manrope", size: 18)!
            cell.contentConfiguration = content
            return cell
        default:
            var cell = UITableViewCell()
            print("error")
            return cell
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
        case favoritesTableView:
            conditionSelected = favorites[indexPath.row + 1]
            performSegue(withIdentifier: "toDiscussionFromCategories", sender: self)
            self.favoritesTableView.deselectRow(at: indexPath, animated: false)
            
            
            
        case categoriesTableView:
            categorySelected = categories[indexPath.row]
            if categories[indexPath.row] == "Blood and Lymph"{
                
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = bloodAndLymphConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Brain, Nerves, and Spinal Cord"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = brainNervesSpinalConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Cancer"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = cancerConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Chromosomal Conditions"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = chromosomalConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Diabetes"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = diabetesConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Ears, Nose, and Throat"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = earsNoseThroatConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Eyes"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = eyesConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Glands"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = glandsConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Heart and Blood Vessels"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = heartBloodVesselsConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Immune System"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = immuneSystemConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Infections and Poisoning"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = infectionsPoisoningConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Injuries"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = injuriesConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Kidneys, Bladder, and Prostate"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = kidneysBladderProstateConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Lungs and Airways"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = lungsAirwaysConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Mental Health"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = mentalHealthConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Mouth"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = mouthConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Muscle, Bone, and Joints"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = muscleBoneJointsConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Nutritional"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = nutritionalConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Pregnancy and Childbirth"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = pregnancyChildbirthConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Sexual and Reproductive"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = sexualReproductiveConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Skin, Hair, and Nails"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = skinHairNailsConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            else if categories[indexPath.row] == "Stomach, Liver, and Gastrointestinal Tract"{
                
                performSegue(withIdentifier: "toConditionsSegue", sender: self)
                conditionsNames = stomachLiverGastrointestinalConditions
                self.categoriesTableView.deselectRow(at: indexPath, animated: false)
            }
            
            
        default:
            print("error")
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch tableView {
        case favoritesTableView:
            let unpin = UIContextualAction(style: .destructive, title: "Pin") { action, _, _ in
                
                
                
                let docRef = self.db.collection("Users").document(Auth.auth().currentUser!.uid)
                
                docRef.getDocument { (document, error) in
                    
                    let result = Result {
                        try document?.data(as: PinnedReference.self)
                        
                    }
                    print(result)
                    switch result {
                    case .success(let pinned):
                        if let pinned = pinned {
                            
                            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                                "pinned": FieldValue.arrayRemove([self.favorites[indexPath.row + 1]])
                            ])
                            self.favorites.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                            tableView.reloadRows(at: [indexPath], with: .automatic)
 
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding question: \(error)")
                    }
                }
                print("success")
                
            }
            unpin.backgroundColor = UIColor.systemIndigo
            unpin.image = UIImage(systemName: "pin.slash.fill")
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [unpin])
            
            return swipeConfiguration
        default:
            let swipeConfiguration = UISwipeActionsConfiguration()
            return swipeConfiguration
            
        }
        
    }
    
    
    
}

extension CategoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchList = alphSortedList.flatMap({ $0 }).filter ({
            $0.lowercased().contains(searchText.lowercased())})
        searchResultsCollectionView.isHidden = false
        
        searchResultsCollectionView.reloadData()
        if searchBar.text == "" {
            searchResultsCollectionView.isHidden = true
            sendRequestButton.isHidden = true
            sendRequestMessage.isHidden = true
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
        searchBar.text = ""
        searchResultsCollectionView.reloadData()
        searchResultsCollectionView.isHidden = true
        sendRequestButton.isHidden = true
        sendRequestMessage.isHidden = true
        
    }
}

// MARK: - Search Conditions CollectionView Setup
extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 350, height: 100)
    }
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideKeyboard()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchList.count == 0 && searchResultsCollectionView.isHidden == false {
            sendRequestButton.isHidden = false
            sendRequestMessage.isHidden = false
        }
        else if searchList.count != 0 && searchResultsCollectionView.isHidden == false{
            sendRequestButton.isHidden = true
            sendRequestMessage.isHidden = true
        }
        
        return searchList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchConditionCell", for: indexPath) as? SearchConditionCollectionViewCell
        
        cell?.searchedConditionName.text = searchList[indexPath.row]
        
        if bloodAndLymphConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Blood and Lymph"
        }
        else if brainNervesSpinalConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Brain, Nerves, and Spinal Cord"
        }
        else if cancerConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Cancer"
        }
        else if chromosomalConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Chromosomal Conditions"
        }
        else if diabetesConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Diabetes"
        }
        else if earsNoseThroatConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Ears, Nose, and Throat"
        }
        else if eyesConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Eyes"
        }
        else if glandsConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Glands"
        }
        else if heartBloodVesselsConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Heart and Blood Vessels"
        }
        else if immuneSystemConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Immune System"
        }
        else if infectionsPoisoningConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Infections and Poisoning"
        }
        else if injuriesConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Injuries"
        }
        else if kidneysBladderProstateConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Kidneys, Bladder, and Prostate"
        }
        else if lungsAirwaysConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Lungs and Airways"
        }
        else if mentalHealthConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Mental Health"
        }
        else if mouthConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Mouth"
        }
        else if muscleBoneJointsConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Muscle, Bone, and Joints"
        }
        else if nutritionalConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Nutritional"
        }
        else if pregnancyChildbirthConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Pregnancy and Childbirth"
        }
        else if sexualReproductiveConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Sexual and Reproductive"
        }
        else if skinHairNailsConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Skin, Hair, and Nails"
        }
        else if stomachLiverGastrointestinalConditions.contains(searchList[indexPath.row]){
            cell?.searchedCategoryName.text = "Stomach, Liver, and Gastrointestinal Tract"
        }
        
        cell?.backgroundColor = UIColor.white
        cell?.layer.cornerRadius = 10
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        conditionSelected = searchList[indexPath.row]
        performSegue(withIdentifier: "toDiscussionFromCategories", sender: self)
        self.favoritesTableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
}

//
//  DataForCustomerOnboarding.swift
//  EFTA1
//
//  Created by Joshua on 4/15/24.
//


import Foundation

struct LocationData {
    var region: String
    var districts: [String]
}

func createLocationData() -> [LocationData] {
    let regions = [
        "Arusha Region", "Dar es Salaam Region", "Dodoma Region", "Geita Region", "Iringa Region",
        "Kagera Region", "Katavi Region", "Kigoma Region", "Kilimanjaro Region", "Lindi Region",
        "Manyara Region", "Mara Region", "Mbeya Region", "Morogoro Region", "Mtwara Region",
        "Mwanza Region", "Njombe Region", "Pemba North Region", "Pemba South Region", "Pwani Region",
        "Rukwa Region", "Ruvuma Region", "Shinyanga Region", "Simiyu Region", "Singida Region",
        "Tabora Region", "Tanga Region", "Zanzibar Central/South Region", "Zanzibar North Region",
        "Zanzibar Urban/West Region", "Songwe Region"
    ]

    let districts = [
        "Arusha Region": ["Arusha", "Arumeru", "Karatu", "Longido", "Meru", "Monduli", "Ngorongoro"],
        "Dar es Salaam Region": ["Ilala", "Kinondoni", "Temeke", "Kigamboni"],
        "Dodoma Region": ["Bahi", "Chamwino", "Chemba", "Dodoma Municipal", "Kondoa", "Kongwa", "Mpwapwa"],
        "Geita Region": [
            "Bukombe",
            "Chato",
            "Geita",
            "Mbogwe",
            "Nyang'hwale"
          ],
          "Iringa Region": [
            "Iringa Municipal",
            "Iringa Rural",
            "Kilolo",
            "Mafinga Town",
            "Mufindi"
          ],
          "Kagera Region": [
            "Biharamulo",
            "Bukoba Municipal",
            "Bukoba Rural",
            "Karagwe",
            "Kyerwa",
            "Missenyi",
            "Muleba",
            "Ngara"
          ],
          "Katavi Region": [
            "Mlele",
            "Mpanda Municipal",
            "Mpanda Rural"
          ],
          "Kigoma Region": [
            "Buhigwe",
            "Kakonko",
            "Kasulu Municipal",
            "Kasulu Rural",
            "Kibondo",
            "Kigoma Municipal",
            "Kigoma-Ujiji Municipal",
            "Uvinza"
          ],
          "Kilimanjaro Region": [
            "Hai",
            "Moshi Municipal",
            "Moshi Rural",
            "Mwanga",
            "Rombo",
            "Same",
            "Siha"
          ],
          "Lindi Region": [
            "Kilwa",
            "Lindi Municipal",
            "Lindi Rural",
            "Liwale",
            "Nachingwea",
            "Ruangwa"
          ],
          "Manyara Region": [
            "Babati Rural",
            "Babati Town",
            "Hanang",
            "Kiteto",
            "Mbulu",
            "Simanjiro"
          ],
          "Mara Region": [
            "Bunda",
            "Butiama",
            "Musoma Municipal",
            "Musoma Rural",
            "Rorya",
            "Serengeti",
            "Tarime"
          ],
          "Mbeya Region": [
            "Busokelo",
            "Chunya",
            "Kyela",
            "Mbarali",
            "Mbeya City",
            "Mbeya Rural",
            "Rungwe"
          ],
          "Morogoro Region": [
            "Gairo",
            "Kilombero",
            "Kilosa",
            "Morogoro Municipal",
            "Morogoro Rural",
            "Mvomero",
            "Ulanga"
          ],
          "Mtwara Region": [
            "Masasi",
            "Mtwara Municipal",
            "Mtwara Rural",
            "Nanyumbu",
            "Newala",
            "Tandahimba"
          ],
          "Mwanza Region": [
            "Ilemela",
            "Kwimba",
            "Magu",
            "Misungwi",
            "Nyamagana",
            "Sengerema",
            "Ukerewe"
          ],
          "Njombe Region": [
            "Ludewa",
            "Makambako Town",
            "Makete",
            "Njombe Town",
            "Njombe Rural",
            "Wanging'ombe"
          ],
          "Pemba North Region": [
            "Micheweni",
            "Wete"
          ],
          "Pemba South Region": [
            "Chake Chake",
            "Mkoani"
          ],
          "Pwani Region": [
            "Bagamoyo",
            "Kibaha Town",
            "Kibaha Urban",
            "Kisarawe",
            "Mafia",
            "Mkuranga",
            "Rufiji"
          ],
          "Rukwa Region": [
            "Kalambo",
            "Nkasi",
            "Sumbawanga Municipal",
            "Sumbawanga Rural"
          ],
          "Ruvuma Region": [
            "Mbinga",
            "Songea Municipal",
            "Songea Rural",
            "Tunduru"
          ],
          "Shinyanga Region": [
            "Kahama Rural",
            "Kahama Town",
            "Kishapu",
            "Shinyanga Municipal",
            "Shinyanga Rural"
          ],
          "Simiyu Region": [
            "Bariadi",
            "Busega",
            "Itilima",
            "Maswa",
            "Meatu"
          ],
          "Singida Region": [
            "Iramba",
            "Singida Municipal",
            "Singida Rural"
          ],
          "Tabora Region": [
            "Igunga",
            "Kaliua",
            "Nzega",
            "Sikonge",
            "Tabora Municipal",
            "Urambo",
            "Uyui"
          ],
          "Tanga Region": [
            "Handeni",
            "Kilindi",
            "Korogwe",
            "Lushoto",
            "Muheza",
            "Mkinga",
            "Pangani",
            "Tanga City"
          ],
          "Zanzibar Central/South Region": [
            "Kati",
            "Kusini"
          ],
          "Zanzibar North Region": [
            "Kaskazini A",
            "Kaskazini B"
          ],
          "Zanzibar Urban/West Region": [
            "Magharibi",
            "Mjini"
          ],
          "Songwe Region": [
            "Ileje",
            "Mbozi",
            "Momba",
            "Songwe"
          ]    ]

    var locationDataArray: [LocationData] = []

    for region in regions {
        if let districtList = districts[region] {
            let locationData = LocationData(region: region, districts: districtList)
            locationDataArray.append(locationData)
        }
    }

    return locationDataArray
}


func createNationalities() -> [String] {
    let nationalities = [
        "Afghan",
        "Albanian",
        "Algerian",
        "American",
        "Andorran",
        "Angolan",
        "Antiguans",
        "Argentinean",
        "Armenian",
        "Australian",
        "Austrian",
        "Azerbaijani",
        "Bahamian",
        "Bahraini",
        "Bangladeshi",
        "Barbadian",
        "Barbudans",
        "Batswana",
        "Belarusian",
        "Belgian",
        "Belizean",
        "Beninese",
        "Bhutanese",
        "Bolivian",
        "Bosnian",
        "Brazilian",
        "British",
        "Bruneian",
        "Bulgarian",
        "Burkinabe",
        "Burmese",
        "Burundian",
        "Cambodian",
        "Cameroonian",
        "Canadian",
        "Cape Verdean",
        "Central African",
        "Chadian",
        "Chilean",
        "Chinese",
        "Colombian",
        "Comoran",
        "Congolese",
        "Costa Rican",
        "Croatian",
        "Cuban",
        "Cypriot",
        "Czech",
        "Danish",
        "Djibouti",
        "Dominican",
        "Dutch",
        "East Timorese",
        "Ecuadorean",
        "Egyptian",
        "Emirian",
        "Equatorial Guinean",
        "Eritrean",
        "Estonian",
        "Ethiopian",
        "Fijian",
        "Filipino",
        "Finnish",
        "French",
        "Gabonese",
        "Gambian",
        "Georgian",
        "German",
        "Ghanaian",
        "Greek",
        "Grenadian",
        "Guatemalan",
        "Guinea-Bissauan",
        "Guinean",
        "Guyanese",
        "Haitian",
        "Herzegovinian",
        "Honduran",
        "Hungarian",
        "Icelander",
        "Indian",
        "Indonesian",
        "Iranian",
        "Iraqi",
        "Irish",
        "Israeli",
        "Italian",
        "Ivorian",
        "Jamaican",
        "Japanese",
        "Jordanian",
        "Kazakhstani",
        "Kenyan",
        "Kittian and Nevisian",
        "Kuwaiti",
        "Kyrgyz",
        "Laotian",
        "Latvian",
        "Lebanese",
        "Liberian",
        "Libyan",
        "Liechtensteiner",
        "Lithuanian",
        "Luxembourger",
        "Macedonian",
        "Malagasy",
        "Malawian",
        "Malaysian",
        "Maldivan",
        "Malian",
        "Maltese",
        "Marshallese",
        "Mauritanian",
        "Mauritian",
        "Mexican",
        "Micronesian",
        "Moldovan",
        "Monacan",
        "Mongolian",
        "Moroccan",
        "Mosotho",
        "Motswana",
        "Mozambican",
        "Namibian",
        "Nauruan",
        "Nepalese",
        "New Zealander",
        "Ni-Vanuatu",
        "Nicaraguan",
        "Nigerian",
        "Nigerien",
        "North Korean",
        "Northern Irish",
        "Norwegian",
        "Omani",
        "Pakistani",
        "Palauan",
        "Panamanian",
        "Papua New Guinean",
        "Paraguayan",
        "Peruvian",
        "Polish",
        "Portuguese",
        "Qatari",
        "Romanian",
        "Russian",
        "Rwandan",
        "Saint Lucian",
        "Salvadoran",
        "Samoan",
        "San Marinese",
        "Sao Tomean",
        "Saudi",
        "Scottish",
        "Senegalese",
        "Serbian",
        "Seychellois",
        "Sierra Leonean",
        "Singaporean",
        "Slovakian",
        "Slovenian",
        "Solomon Islander",
        "Somali",
        "South African",
        "South Korean",
        "Spanish",
        "Sri Lankan",
        "Sudanese",
        "Surinamer",
        "Swazi",
        "Swedish",
        "Swiss",
        "Syrian",
        "Taiwanese",
        "Tajik",
        "Tanzanian",
        "Thai",
        "Togolese",
        "Tongan",
        "Trinidadian or Tobagonian",
        "Tunisian",
        "Turkish",
        "Tuvaluan",
        "Ugandan",
        "Ukrainian",
        "Uruguayan",
        "Uzbekistani",
        "Venezuelan",
        "Vietnamese",
        "Welsh",
        "Yemenite",
        "Zambian",
        "Zimbabwean"
      ]
    
   
    
    return nationalities
    

    
}


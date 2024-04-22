//
//  DataHandler.swift
//  EFTA1
//
//  Created by Joshua on 4/18/24.
//

import Combine
import UIKit
import SwiftUI
import MapKit


class PinHandler: ObservableObject {
    @Published var pinCode :String = ""
    @Published var selectedQuestion1: String?
    @Published var selectedQuestion2: String?
    @Published var selectedQuestion3: String?
    @Published var answer1: String = ""
    @Published var answer2: String = ""
    @Published var answer3: String = ""
    @Published var staffNumber = ""
    @Published var phoneNumber = ""

  



}

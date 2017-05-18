//
//  DateFormatter+Utilities.swift
//  Movies
//
//  Created by Praveen Sitaraman on 5/17/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    convenience init(format: String, locale: Locale = Locale(identifier: "en_US_POSIX")) {
        self.init()
        self.dateFormat = format
        self.locale = locale
    }
}

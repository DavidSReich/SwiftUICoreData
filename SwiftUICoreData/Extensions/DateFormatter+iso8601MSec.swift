//
//  DateFormatter+iso8601MSec.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 5/1/21.
//  Copyright © 2021 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let iso8601MSec: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

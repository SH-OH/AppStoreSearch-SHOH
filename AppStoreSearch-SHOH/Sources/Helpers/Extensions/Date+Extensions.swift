//
//  Date+Extensions.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/24.
//

import Foundation

extension Date {
    var ago: String {
        let components: Set<Calendar.Component> = [
            .year, .month, .weekday,
            .day, .hour, .minute, .second
        ]
        let dateComponents = Calendar.current.dateComponents(
            components,
            from: self,
            to: Date()
        )
        
        if let year = dateComponents.year, year > 0 {
            return "\(abs(year))년 전"
            
        } else if let month = dateComponents.month, month > 0 {
            return "\(abs(month))개월 전"
            
        } else if let week = dateComponents.weekday, week > 0 {
            return "\(abs(week))주 전"
            
        } else if let day = dateComponents.day, day > 0 {
            return "\(abs(day))일 전"
            
        } else if let hour = dateComponents.hour, hour > 0 {
            return "\(abs(hour))시간 전"
            
        } else if let minute = dateComponents.minute, minute > 0 {
            return "\(abs(minute))분 전"
            
        } else {
            return "방금 전"
        }
    }
}

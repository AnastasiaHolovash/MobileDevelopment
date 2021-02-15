//
//  Validator.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 15.02.2021.
//

import Foundation

// MARK: - ValidationCriterion Protocol

public protocol ValidationCriterion {
    
    /// string for description of criterion
    var errorDescription : String {get}
    
    /// Check if value conform to criteria
    ///
    /// - Parameter value: value to be checked
    /// - Returns: return true if conform
    func isConform(to value:String) -> Bool
}

// MARK: - Validator

class Validator  {
    
    static let yearCriterions: [ValidationCriterion] = [IsIntNumberCriteria(), IsRealYearCriteria()]
    
    private let criterions: [ValidationCriterion]
    
    public init(of type: ValidatorType) {
        
        switch type {
        case .year:
            self.criterions = Self.yearCriterions
        }
    }
    
    /// validate redictors to comform
    ///
    /// - Parameters:
    ///   - value: string than must be validate
    ///   - forceExit: if true -> stop process when first validation fail. else create array of fail criterias
    ///   - result: result of validating
    public func isValide(_ value:String, forceExit:Bool, result:@escaping  (ValidatorResult) -> ()) {
        
        var notPassedCriterions: [ValidationCriterion] = []
        
        for criteria in criterions {
            if !criteria.isConform(to: value) {
                if forceExit {
                    result(.notValid(criteria: criteria))
                    return ()
                }
                notPassedCriterions.append(criteria)
            }
        }
        
        notPassedCriterions.isEmpty ? result(.valid) : result (.notValides(criterias: notPassedCriterions))
    }
    
    /// Type of data that will be validating
    public enum ValidatorType {
        case year
    }
    
    /// Validator result object
    ///
    /// - valid: everething if ok
    /// - notValid: find not valid criteria
    /// - notValide: not valid  array of criterias
    public enum ValidatorResult {
        
        case valid
        case notValid(criteria:ValidationCriterion)
        case notValides(criterias:[ValidationCriterion])
    }
}

// MARK: - IsIntNumberCriteria

public struct IsIntNumberCriteria : ValidationCriterion {
    
    public var errorDescription: String = "Not an integer entered."
    
    public func isConform(to value: String) -> Bool {
        
        return Int(value) != nil ? true : false
    }
}

// MARK: - IsRealYearCriteria

public struct IsRealYearCriteria : ValidationCriterion {
    
    public var errorDescription: String = "Not a real year entered."
    
    public func isConform(to value: String) -> Bool {
        
        guard let year = Int(value) else {
            return false
        }
        
        return (1685..<10000).contains(year) ? true : false
    }
}

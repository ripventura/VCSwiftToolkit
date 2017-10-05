//
//  Structs.swift
//  VCSwiftToolkit
//
//  Created by Vitor Cesco on 05/10/17.
//

import Foundation

public protocol ReadableIntervalLocaleProtocol {
    var justNow: String {get}
    var about: String {get}
    var futureAddon: String {get}
    var pastAddon: String {get}
    
    var minute: String {get}
    var minutes: String {get}
    var hour: String {get}
    var hours: String {get}
    var day: String {get}
    var days: String {get}
}

public struct EnUSReadableIntervalLocale: ReadableIntervalLocaleProtocol {
    public init() {
        
    }
    
    public var justNow: String {
        get {
            return "justNow"
        }
    }
    public var about: String {
        get {
            return "about"
        }
    }
    public var futureAddon: String {
        get {
            return "in"
        }
    }
    public var pastAddon: String {
        get {
            return "ago"
        }
    }
    
    public var minute: String {
        get {
            return "minute"
        }
    }
    public var minutes: String {
        get {
            return "minutes"
        }
    }
    public var hour: String {
        get {
            return "hour"
        }
    }
    public var hours: String {
        get {
            return "hours"
        }
    }
    public var day: String {
        get {
            return "day"
        }
    }
    public var days: String {
        get {
            return "days"
        }
    }
}

public struct PtBRReadableIntervalLocale: ReadableIntervalLocaleProtocol {
    public init() {
        
    }
    
    public var justNow: String {
        get {
            return "agora há pouco"
        }
    }
    public var about: String {
        get {
            return "aproximadamente"
        }
    }
    public var futureAddon: String {
        get {
            return "em"
        }
    }
    public var pastAddon: String {
        get {
            return "atrás"
        }
    }
    
    public var minute: String {
        get {
            return "minuto"
        }
    }
    public var minutes: String {
        get {
            return "minutos"
        }
    }
    public var hour: String {
        get {
            return "hora"
        }
    }
    public var hours: String {
        get {
            return "horas"
        }
    }
    public var day: String {
        get {
            return "day"
        }
    }
    public var days: String {
        get {
            return "days"
        }
    }
}

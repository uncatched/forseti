//
//  File.swift
//  
//
//  Created by Denys Litvinskyi on 22.09.2021.
//

import Foundation
import ArgumentParser

struct Forseti: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Comand-line tool to test APNs",
                                                    subcommands: [Setup.self, Push.self])
}

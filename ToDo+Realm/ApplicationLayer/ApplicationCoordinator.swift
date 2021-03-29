//
//  ApplicationCoordinator.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 28.02.2021.
//

import InoMvvmc
import Swinject

final class ApplicationCoordinator: BaseCoordinator<Void> {
    override init() {
        super.init()
        assembler = Assembler(assemblies())
      }
    
    override func assemblies() -> [Assembly] {
        return [
            DatabaseAssembly(),
            StartupModuleAssembly()
        ]
    }
    
    override func start() {
        let startupCoordinator = StartupCoordinator()
        
        coordinate(to: startupCoordinator)
    }
}

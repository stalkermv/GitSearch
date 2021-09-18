//
//  DisposeContainer.swift
//  DisposeContainer
//
//  Created by Valeriy Malishevskyi on 14.09.2021.
//

import RxSwift

protocol DisposeContainer {
    var bag: DisposeBag { get }
}

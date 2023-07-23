//
//  Observable.swift
//  iOSBA
//
//  Created by Oswaldo Ferral on 18/07/23.
//

import Foundation

final class Observable<T>{
    
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T?){
        self.value = value
    }
    
    private var listener:((T?) -> ())?
    
    ///Esto simplemente da el aviso de que listener ya tiene un nuevo valor , y te va contestar a quien debe de hacer un reload donde necesitas
    func bind(_ listener: @escaping (T?) -> ()) {
        
        listener(value)
        
        self.listener = listener
        
    }
    
}

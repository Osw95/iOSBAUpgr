
//
//  FavoriteTableViewModel.swift
//  FavoriteTableViewModel
//
//  Created by Oswaldo Ferral on 18/07/23.
//

import XCTest
@testable import iOSBA

final class FavoriteTableViewModeliOSBATest: XCTestCase {
    
    private var sut:FavoriteTableViewModel!
    
    let dataLoad = dataManager().movies

    override func setUpWithError() throws {
        super.setUp()
        
        sut = FavoriteTableViewModel()
        
        let tvshowList = try? JSONDecoder().decode([tvshow].self, from: dataLoad)
        
        sut.getDataCoreData()
        
    }

    override func tearDownWithError() throws {
        sut = nil
        
        super.tearDown()
    
    }
    
    func testOfMethod_getData_getTrue(){
        
        let valorIndex = sut.tvShowFavorites.value?.count ?? 0
        
        print(valorIndex)
                    
        XCTAssertGreaterThan(valorIndex,0)
        
    }
    
    func testOfMethod_deleteCoreData_getTrue(){
        
        let BoolOfMethod = sut.deleteCoreData(deleteFavShow: sut.tvShowFavorites.value?[0])
        
        print(BoolOfMethod)
        
        XCTAssertTrue(BoolOfMethod)
        
    }
    
    
  
    


}


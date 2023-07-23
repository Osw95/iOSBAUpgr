//
//  iOSBATests.swift
//  iOSBATests
//
//  Created by Oswaldo Ferral on 18/07/23.
//

import XCTest
@testable import iOSBA

final class MovieTableViewModeliOSBATest: XCTestCase {
    
    private var sut:MovieTableViewModel!
    
    let dataLoad = dataManager().movies

    override func setUpWithError() throws {
        super.setUp()
        
        sut = MovieTableViewModel()
        
        let tvshowList = try? JSONDecoder().decode([tvshow].self, from: dataLoad)
        
        guard let dataTest = tvshowList?[0] else { return }
        
        _ = sut.addCoreData(dataFav: dataTest)
        
    }

    override func tearDownWithError() throws {
        sut = nil
        
        super.tearDown()
    
    }
    
    func testOfMethod_addCoreData_getTrue(){
        
        let tvshowList = try? JSONDecoder().decode([tvshow].self, from: dataLoad)
        
        guard let dataTest = tvshowList?[1] else { return }
            
        XCTAssertTrue(sut.addCoreData(dataFav: dataTest))
        
        
    }

    func testOfMethod_deleteCoreData_getTrue() throws {
        
        let tvshowList = try? JSONDecoder().decode([tvshow].self, from: dataLoad)
        
        guard let dataTest = tvshowList?[0] else { return }
            
        XCTAssertTrue(sut.deleteCoredata(dataTest))
            
        
    }
    
    func testOfMethod_validateCoredata_getTrue() throws {
        
        let tvshowList = try? JSONDecoder().decode([tvshow].self, from: dataLoad)
        
        guard let dataTest = tvshowList?[1] else { return }
            
        XCTAssertTrue(sut.validateCoredata(dataTest))
        
    }

}

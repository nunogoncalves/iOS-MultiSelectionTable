//
//  MultiSelectionTableTests.swift
//  MultiSelectionTableTests
//
//  Created by Nuno Gonçalves on 28/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import MultiSelectionTable

class MultiSelectionTableTests: XCTestCase {
    
    var multiSelectionDataSource: MultiSelectionDataSource<Int>!
    let multiSelectionTableView = MultiSelectionTableView()
    
    override func setUp() {
        super.setUp()
        
        multiSelectionDataSource = MultiSelectionDataSource(control: multiSelectionTableView)
        multiSelectionTableView.dataSource = multiSelectionDataSource
        
        multiSelectionDataSource.register(nib: UINib(nibName: "AlbumCell", bundle: nil), for: "AlbumCell")
        multiSelectionDataSource.allItems = [1, 2, 3]
        
        let view = MultiSelectionTableView()
        view.dataSource = multiSelectionDataSource
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllItemsCount() {
        XCTAssert(multiSelectionDataSource.allItemsCount == 3, "All items should be three")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testInitialSelectedItemsCount() {
        XCTAssert(multiSelectionDataSource.selectedItemsCount == 0, "Selected Items should be zero at first")
    }
    
    func testSelectedItemsCountAfterOneSelection() {
        multiSelectionDataSource.selectedItem(at: 0)
        let selectedItems = multiSelectionDataSource.selectedItems
        XCTAssert(selectedItems.count == 1, "Selected Items should be one after selecting one item")
        XCTAssert(selectedItems.first == 1, "First item should be 1")
    }
    
    func testAllItemsCountAfterOneSelection() {
        multiSelectionDataSource.selectedItem(at: 0)
        
        let allItems = multiSelectionDataSource.allItems
        XCTAssert(allItems.count == 3, "All items should remain the same")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

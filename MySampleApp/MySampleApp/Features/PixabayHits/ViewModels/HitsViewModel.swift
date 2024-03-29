//
//  HitsViewModel.swift
//  MySampleApp
//
//  Created by Alex Núñez on 09/06/2019.
//  Copyright © 2019 All rights reserved.
//

import Foundation
import Bond
import MySampleAPI

/// HitsViewModels contains presentation logic for preparing data to be shown by the View
final internal class HitsViewModel: HitsViewModelProtocol {
	
	private (set) var interactor: HitsInteractorProtocol
	private (set) var coordinator: HitsCoordinatorProtocol
	
	private (set) var listData = Observable<[Hit]>([])
	private (set) var error = Observable<Error?>(nil)
	private (set) var refreshing = Observable<Bool>(false)
	
	/// Initializer
	///
	/// - Parameters:
	///   - interactor: hits model
	///   - coordinator: instance of the coordinator
	init(interactor: HitsInteractorProtocol, coordinator: HitsCoordinatorProtocol) {
		self.interactor = interactor
		self.coordinator = coordinator
	}
	
	/// Navigation Bar Title
	var title: String {
		return "Pixabay Hits"
	}
	
	/// Calls the iterator and update the listdata with the new models
	func fetchHits() {
		refreshing.value = true
		
		interactor.fetchHits({ [weak self] (result) in
			self?.refreshing.value = false
			
			switch result {
			case .success(let models):
				self?.listData.value = models
			case .failure(let error):
				self?.error.value = error
			}						
		})
	}
	
	/// numberOfItems
	///
	/// - Returns: return the number of items of listdata
	func numberOfItems() -> Int {
		return listData.value.count
	}
	
	/// numberOfSections
	///
	/// - Returns: Returns the number of sections
	func numberOfSections() -> Int {
		return 1
	}
	
	/// Returns the item at the specified index path.
	///
	/// - Parameter forRowAt: The index path locating the item in the list.
	/// - Returns: A view model representing an item of the list.
	func data(forRowAt index: IndexPath) -> HitCollectionCellViewModelProtocol {
		let model = listData.value[index.row]
		return HitCollectionCellViewModel(interactor: HitsInteractor(getFromUrl: model.largeImageURL), model: model)
	}
	
	func showHit(forRowAt index: IndexPath) {
		let hit = listData.value[index.row]
		coordinator.present(hit: hit)
	}
	
	/// Dimiss action, it notifices teh coordinator when we are finished
	func finish() {
		coordinator.finish()
	}
}

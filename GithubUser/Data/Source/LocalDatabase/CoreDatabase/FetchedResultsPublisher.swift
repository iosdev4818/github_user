//
//  FetchedResultsPublisher.swift
//  Data
//
//  Created by Bao Nguyen on 13/2/25.
//

import Combine
import CoreData


/// Wrap NSFetchedResultsController and return it as an Publisher
class FetchedResultsPublisher<T: NSFetchRequestResult>: Publisher {
    typealias Output = [T]
    typealias Failure = Never

    private let fetchedResultsController: NSFetchedResultsController<T>

    init(
        fetchRequest: NSFetchRequest<T>,
        in context: NSManagedObjectContext,
        sectionNameKeyPath: String? = nil,
        cacheName: String? = nil
    ) {
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: cacheName
        )
    }

    func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
        let subscription = FetchedResultsSubscription(
            fetchedResultsController: fetchedResultsController,
            subscriber: subscriber
        )
        subscriber.receive(subscription: subscription)
    }

    private class FetchedResultsSubscription<S: Subscriber>: NSObject, Subscription, NSFetchedResultsControllerDelegate
    where S.Input == Output, S.Failure == Failure {
        private let fetchedResultsController: NSFetchedResultsController<T>
        private var subscriber: S?
        private var demand: Subscribers.Demand

        init(fetchedResultsController: NSFetchedResultsController<T>, subscriber: S) {
            self.fetchedResultsController = fetchedResultsController
            self.subscriber = subscriber
            self.demand = .none
            super.init()

            self.fetchedResultsController.delegate = self

            fetchedResultsController.managedObjectContext.performAndWait {
                try? self.fetchedResultsController.performFetch()
            }
        }

        func request(_ demand: Subscribers.Demand) {
            processNewDemand(demand)
            fetchedResultsController.managedObjectContext.performAndWait {
                self.processFetchedObjects(from: self.fetchedResultsController)
            }
        }

        func cancel() {
            subscriber = nil
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            guard let controller = controller as? NSFetchedResultsController<T> else {
                return
            }

            processFetchedObjects(from: controller)
        }

        private func processFetchedObjects(from controller: NSFetchedResultsController<T>) {
            guard let subscriber = subscriber else {
                return
            }

            if demand > 0 {
                processNewDemand(subscriber.receive(controller.fetchedObjects ?? []))
            } else {
                subscriber.receive(completion: .finished)
                cancel()
            }
        }

        private func processNewDemand(_ newDemand: Subscribers.Demand) {
            if demand != .unlimited {
                demand = newDemand
            }
        }
    }
}

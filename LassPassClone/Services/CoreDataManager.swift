//
//  CoreDataManager.swift
//  LassPassClone
//
//  Created by Vinh Nguyen Dinh on 2020/06/02.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import Combine
import CoreData
import UIKit

class CoreDataManager: ObservableObject {
    var context: NSManagedObjectContext
    
    static let shared = CoreDataManager(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    @Published var notePredicate = NSPredicate(value: true)
    @Published var passwordPredicate = NSPredicate(value: true)
    @Published var sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
    
    @Published var searchTerm = ""
    
    @Published var showNotes = true
    @Published var showPasswords = true
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func save() -> Bool {
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch let error {
                print("Error saving changes to the context’s parent store.: \(error.localizedDescription)")
                return false
            }
        }
        return true
    }
    
    func updateLastUsedPassword(with id: UUID) -> Bool  {
        let request: NSFetchRequest<PasswordItem> = PasswordItem.fetchRequest() as! NSFetchRequest<PasswordItem>
        request.predicate = NSPredicate(format: "id = %@", id.uuidString)
        
        do {
            let results = try context.fetch(request)
            results[0].setValue(Date(), forKey: "lastUsed")
            return save()
            
        } catch let error {
            print(error)
        }
        
        return false
    }
    
    func setFavoritePassword(_ password: PasswordViewModel) -> Bool  {
        let request: NSFetchRequest<PasswordItem> = PasswordItem.fetchRequest() as! NSFetchRequest<PasswordItem>
        request.predicate = NSPredicate(format: "id = %@", password.id.uuidString)
        let isFavorite = password.isFavorite ? 0 : 1
        do {
            let results = try context.fetch(request)
            results[0].setValue(isFavorite, forKey: "isFavorite")
            return save()
            
        } catch let error {
            print(error)
        }
        
        return false
    }
    
    func updateLastUsedNote(with id: UUID) -> Bool  {
        let request: NSFetchRequest<NoteItem> = NoteItem.fetchRequest() as! NSFetchRequest<NoteItem>
        request.predicate = NSPredicate(format: "id = %@", id.uuidString)
        
        do {
            let results = try context.fetch(request)
            results[0].setValue(Date(), forKey: "lastUsed")
            return save()
            
        } catch let error {
            print(error)
        }
        
        return false
    }
    
    func setFavoriteNote(_ note: NoteViewModel) -> Bool  {
        let request: NSFetchRequest<NoteItem> = NoteItem.fetchRequest() as! NSFetchRequest<NoteItem>
        request.predicate = NSPredicate(format: "id = %@", note.id.uuidString)
        
        let isFavorite = note.isFavorite ? 0 : 1
        
        do {
            let results = try context.fetch(request)
            results[0].setValue(isFavorite , forKey: "isFavorite")
            return save()
            
        } catch let error {
            print(error)
        }
        
        return false
    }
    
    func performSearch()  {
        let passwordSearchPublisher = self.$searchTerm.debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { term in
                
                return term.isEmpty ? NSPredicate.init(value: true) : NSPredicate(format: "site CONTAINS[c] %@ || username CONTAINS[c] %@", term, term)
        }.eraseToAnyPublisher()
        
        let noteSearchPublisher = self.$searchTerm.debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { term in
                return term.isEmpty ? NSPredicate.init(value: true) : NSPredicate(format: "name CONTAINS[c] %@", term)
        }.eraseToAnyPublisher()
        
        Publishers.CombineLatest(passwordSearchPublisher, noteSearchPublisher)
            .receive(on: DispatchQueue.main)
            .sink {[unowned self] (passwordPred, notepred) in
                self.passwordPredicate = passwordPred
                self.notePredicate = notepred
        }.store(in: &self.cancellableSet)
    }
    
    func applyFilter(_ filter: Filter) {
        self.sortDescriptor = NSSortDescriptor(keyPath: \PasswordItem.createdAt, ascending: false)
        self.passwordPredicate = NSPredicate(value: true)
        self.notePredicate =  NSPredicate(value: true)
        
        switch filter {
        case .MostUsed:
            self.sortDescriptor = NSSortDescriptor(keyPath: \PasswordItem.lastUsed, ascending: false)
            
        case .Favorites:
            self.passwordPredicate = NSPredicate(format: "isFavorite = %@", "1")
            self.notePredicate = NSPredicate(format: "isFavorite = %@", "1")
            
        case .Notes:
            self.showPasswords = false
            self.showNotes = true
            
        case .Passwords:
            self.showNotes = false
            self.showPasswords = true
            
        case .AllItems:
            self.showNotes = true
            self.showPasswords = true
        }
    }
}

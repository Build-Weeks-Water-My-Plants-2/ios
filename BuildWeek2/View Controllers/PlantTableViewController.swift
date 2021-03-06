import UIKit
import CoreData
import CoreDataStack

class PlantTableViewController: UITableViewController {
   // MARK: - Properties
   
   let apiController = APIController.shared
   
   // Fetching Core Data Properties
   lazy var fetchedResultsController: NSFetchedResultsController<Plant> = {
      let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
      fetchRequest.sortDescriptors = [
         NSSortDescriptor(key: "nickname", ascending: true)
      ]
      let context = CoreDataStack.shared.mainContext
      let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: context,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
      
      fetchedResultsController.delegate = self
      
      do {
         try fetchedResultsController.performFetch()
      } catch {
         print("\(error)")
      }
      
      return fetchedResultsController
   }()
   
   // MARK: - App LifeCycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      if apiController.bearer == nil {
         performSegue(withIdentifier: "SignInSegue", sender: self)
         return
      }
      
      self.update()
   }
   
   // MARK: - IBActions
   
   @IBAction func refreshButtonTapped(_ sender: Any) {
      self.update()
   }
   
   // MARK: - Update
   
   private func update() {
      apiController.fetchPlantsFromDatabase { result in
         guard case .success(let representation) = result else {
            return
         }
         
         CoreDataHelper.updatePlants(with: representation)
         // We dont need reloadTableView here, fetchedResultsController will update it
      }
   }
   
   // MARK: - Table view data source
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      fetchedResultsController.sections?[section].numberOfObjects ?? 0
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as? PlantTableViewCell else { return UITableViewCell() }
      cell.plant = fetchedResultsController.object(at: indexPath)
      return cell
   }
   
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
         let plant = fetchedResultsController.object(at: indexPath)
         guard let plantRepresentation = plant.plantRepresentation else {
            return
         }
         
         apiController.deletePlantsFromDatabase(plantRepresentation) { result in
            
            guard let _ = try? result.get() else { return }
            
            DispatchQueue.main.async {
               let moc = CoreDataStack.shared.mainContext
               moc.delete(plant)
               do {
                  try moc.save()
                  tableView.reloadData()
               } catch {
                  moc.reset()
                  print("Error saving managed object context: \(error)")
               }
            }
         }
      }
   }
   
   // MARK: - Navigation
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "ShowDetailSegue"{
         if let detailVC = segue.destination as? DetailViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            detailVC.plant = fetchedResultsController.object(at: indexPath)
         }
      }
   }
}

// MARK: - Extensions

extension PlantTableViewController: NSFetchedResultsControllerDelegate {
   func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.beginUpdates()
   }
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.endUpdates()
   }
   func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                   didChange sectionInfo: NSFetchedResultsSectionInfo,
                   atSectionIndex sectionIndex: Int,
                   for type: NSFetchedResultsChangeType) {
      switch type {
      case .insert:
         tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
      case .delete:
         tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
      default:
         break
      }
   }
   func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                   didChange anObject: Any,
                   at indexPath: IndexPath?,
                   for type: NSFetchedResultsChangeType,
                   newIndexPath: IndexPath?) {
      switch type {
      case .insert:
         guard let newIndexPath = newIndexPath else { return }
         tableView.insertRows(at: [newIndexPath], with: .fade)
      case .update:
         guard let indexPath = indexPath else { return }
         tableView.reloadRows(at: [indexPath], with: .none)
      case .move:
         guard let oldIndexPath = indexPath,
            let newIndexPath = newIndexPath else { return }
         tableView.deleteRows(at: [oldIndexPath], with: .fade)
         tableView.insertRows(at: [newIndexPath], with: .fade)
      case .delete:
         guard let indexPath = indexPath else { return }
         tableView.deleteRows(at: [indexPath], with: .fade)
      @unknown default:
         break
      }
   }
}

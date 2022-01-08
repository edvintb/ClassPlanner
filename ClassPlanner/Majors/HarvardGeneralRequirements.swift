//import Foundation
//import CoreData
//
//func createGeneralRequirements(context: NSManagedObjectContext) {
//    let genEdName = "General Requirements"
//    let predicate = NSPredicate(format: "name_ == %@", argumentArray: [genEdName])
//    let fetchRequest = Concentration.fetchRequest(predicate)
//    let resultCount = try? context.count(for: fetchRequest)
//    if (resultCount != 0) { return }
//
//    let concentration = Concentration(context: context)
//    concentration.name = genEdName
//    concentration.colorOption
//
//    if let aesthetcis = concentration.addCategory() {
//        aesthetcis.name = "Aesthetics & Culture"
//        aesthetcis.numberOfRequired = 1
//        aesthetcis.color = 3
//        aesthetcis.notes =
//        """
//        Aesthetics & Culture courses foster critical engagement with diverse artistic and creative endeavors and traditions across history and geographical locations, helping students situate themselves and others as participants in and products of art and culture.
//        """
//    }
//
//    if let ethics = concentration.addCategory() {
//        ethics.name = "Ethics & Civics"
//        ethics.numberOfRequired = 1
//        ethics.color = 7
//        ethics.notes =
//        """
//        Ethics & Civics courses examine the dilemmas that individuals, communities, and societies face as they explore questions of virtue, justice, equity, inclusion, and the greater good.
//        """
//    }
//
//    if let history = concentration.addCategory() {
//        history.name = "History, Society, Individuals"
//        history.numberOfRequired = 1
//        history.color = 6
//        history.notes =
//        """
//        Histories, Societies, Individuals courses explore the dynamic relationships between individuals and larger social, economic and political structures, both historically and in the present moment.
//        """
//    }
//
//    if let science = concentration.addCategory() {
//        science.name = "Science & Technology in Society"
//        science.numberOfRequired = 1
//        science.color = 11
//        science.notes =
//        """
//        Science & Technology in Society courses explore scientific and technological ideas and practices in their social and historical contexts, providing a foundation to assess their promise and perils. STS courses engage students in the practice of science, not just the study of scientific findings.
//        """
//    }
//
//    if let distribution = concentration.addCategory() {
//        distribution.name = "Divisional Distribution"
//        distribution.numberOfRequired = 3
//        distribution.color = 9
//        distribution.notes =
//        """
//        Each student at Harvard College must complete one departmental (non-Gen Ed) course in each of the three main divisions of the Faculty of Arts and Sciences (FAS) and the Paulson School of Engineering and Applied Sciences (SEAS):
//
//        Arts and Humanities, Social Sciences, Science and Engineering and Applied Science
//
//        The online course catalogue contains information about which distribution requirement a course will fulfill.
//        """
//    }
//
//    if let expos = concentration.addCategory() {
//        expos.name = "Expository Writing"
//        expos.numberOfRequired = 1
//        expos.color = 12
//        expos.notes = """
//            Expos 20 is the cornerstone course offering by the Harvard College Writing Program and fulfills the College's expository writing requirement. The class is known to differ a lot between sections so make sure to talk to pepole and pick a good one.
//
//            One can also fullfill the requirement by taking Expos Studio 10 and Expos Studio 20. This is less common, but certainly a viable option.
//            """
//    }
//}

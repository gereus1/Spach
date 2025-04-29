import RealmSwift

/// Всі райони Києва
enum District: String, PersistableEnum, CaseIterable, Identifiable {
    case shevchenkivskyi   = "Шевченківський"
    case solomianskyi      = "Солом'янський"
    case holosiivskyi      = "Голосіївський"
    case pecherskyi        = "Печерський"
    case podilskyi         = "Подільський"
    case darnytskyi        = "Дарницький"
    case dniprovskyi       = "Дніпровський"
    case desnianskyi       = "Деснянський"
    case sviatoshynskyi    = "Святошинський"
    case obolonskyi        = "Оболонський"

    var id: String { rawValue }
}

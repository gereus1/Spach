import RealmSwift

enum SportCategory: String, PersistableEnum, CaseIterable, Identifiable {
    case weightlifting        = "Важка атлетика"
    case athletics            = "Легка атлетика"
    case bodybuilding         = "Бодібілдинг"
    case fitness              = "Фітнес"
    case crossfit             = "Кросфіт"
    case yoga                 = "Йога"
    case pilates              = "Пілатес"
    case boxing               = "Бокс"
    case kickboxing           = "Кікбоксинг"
    case martialArts          = "Єдиноборства"
    case swimming             = "Плавання"
    case running              = "Біг"
    case cycling              = "Велоспорт"
    case stretching           = "Стретчинг"
    case danceFitness         = "Танцювальний фітнес"
    case rehabilitation       = "Реабілітація"
    case personalTraining     = "Персональні тренування"
    case groupTraining        = "Групові тренування"
    case powerlifting         = "Пауерліфтинг"
    case calisthenics         = "Каллістеніка"

    var id: String { rawValue }
}

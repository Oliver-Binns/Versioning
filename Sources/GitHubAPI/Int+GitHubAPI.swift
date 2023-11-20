extension Int {
    var isSuccessful: Bool {
        (200...299).contains(self)
    }
}

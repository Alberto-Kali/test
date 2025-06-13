use std::sync::Mutex;

pub struct AppState {
    // Можно добавить подключение к БД и другие ресурсы
    pub counter: Mutex<i32>,
}

impl AppState {
    pub fn new() -> Self {
        AppState {
            counter: Mutex::new(0),
        }
    }
}

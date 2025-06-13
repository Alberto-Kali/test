use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Item {
    pub id: i32,
    pub name: String,
    pub description: Option<String>,
    pub price: f64,
}

#[derive(Debug, Deserialize)]
pub struct ItemCreate {
    pub name: String,
    pub description: Option<String>,
    pub price: f64,
}

use actix_web::{web, HttpResponse, Responder};
use crate::models::item::{Item, ItemCreate};
use crate::app_state::AppState;
use crate::errors::ApiError;

pub async fn create_item(
    item: web::Json<ItemCreate>,
    data: web::Data<AppState>,
) -> Result<HttpResponse, ApiError> {
    // Здесь можно добавить логику сохранения
    let new_item = Item {
        id: 1,
        name: item.name.clone(),
        description: item.description.clone(),
        price: item.price,
    };
    
    Ok(HttpResponse::Created().json(new_item))
}

pub async fn get_item(
    item_id: web::Path<i32>,
) -> Result<HttpResponse, ApiError> {
    if *item_id == 42 {
        return Err(ApiError::NotFound("Item not found".into()));
    }
    Ok(HttpResponse::Ok().json(item_id.into_inner()))
}

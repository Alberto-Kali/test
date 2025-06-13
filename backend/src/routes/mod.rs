use actix_web::web;

mod items;

pub fn config(cfg: &mut web::ServiceConfig) {
    cfg.service(
        web::scope("/items")
            .route("", web::post().to(items::create_item))
            .route("/{item_id}", web::get().to(items::get_item)),
    );
}

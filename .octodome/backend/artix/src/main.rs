use actix_web::{web, App, HttpServer};
use dotenv::dotenv;
use std::env;

mod routes;
mod models;
mod errors;
mod app_state;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();
    
    let host = env::var("HOST").unwrap_or("127.0.0.1".to_string());
    let port = env::var("PORT").unwrap_or("8080".to_string()).parse().unwrap();
    
    HttpServer::new(|| {
        App::new()
            .app_data(web::Data::new(app_state::AppState::new()))
            .service(web::scope("/api").configure(routes::config))
            .route("/", web::get().to(|| async { "Hello World!" }))
    })
    .bind((host, port))?
    .run()
    .await
}

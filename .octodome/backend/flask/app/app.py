from flask import Flask
from app.config import Config
from app.routes.api import api_blueprint

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    
    # Регистрация blueprint
    app.register_blueprint(api_blueprint, url_prefix='/api')
    
    @app.route('/')
    def home():
        return {'message': 'Hello World'}
    
    return app

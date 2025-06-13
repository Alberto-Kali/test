from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    PROJECT_NAME: str = "FastAPI Backend"
    VERSION: str = "0.1.0"
    DATABASE_URL: str = "sqlite:///./test.db"
    
    class Config:
        env_file = ".env"

settings = Settings()

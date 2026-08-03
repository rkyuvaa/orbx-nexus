from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    PROJECT_NAME: str = "OrbX Nexus ERP"
    API_V1_STR: str = "/api/v1"

    DATABASE_URL: str = "postgresql+psycopg://orbx:orbx_secret@localhost:5432/orbx_nexus"
    REDIS_URL: str = "redis://localhost:6379"

    SECRET_KEY: str = "orbx-nexus-super-secret-key-change-in-production-2024"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 480  # 8 hours

    class Config:
        env_file = ".env"
        extra = "ignore"


@lru_cache()
def get_settings() -> Settings:
    return Settings()


settings = get_settings()

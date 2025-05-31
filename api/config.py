import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

class Settings:
    # API Keys
    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")
    TAVILY_API_KEY = os.getenv("TAVILY_API_KEY", "")
    
    # FastAPI Settings
    HOST = os.getenv("HOST", "localhost")
    PORT = int(os.getenv("PORT", 8000))
    DEBUG = os.getenv("DEBUG", "True").lower() == "true"
    
    # CORS Settings
    FRONTEND_URL = os.getenv("FRONTEND_URL", "http://localhost:5173")
    
    # Allowed CORS origins - production ve development için
    CORS_ORIGINS = [
        "http://localhost:3000",
        "http://localhost:5173",
        "http://127.0.0.1:5173",
        "http://localhost:80",
        "http://127.0.0.1:80",
        FRONTEND_URL
    ]
    
    # Production'da wildcard domain'leri de ekle
    if not DEBUG and FRONTEND_URL:
        # Cloudflare tunnel domain'ini ekle
        CORS_ORIGINS.append(FRONTEND_URL)
        # Subdomain'leri de destekle
        if "trycloudflare.com" in FRONTEND_URL:
            CORS_ORIGINS.append("https://*.trycloudflare.com")

settings = Settings() 
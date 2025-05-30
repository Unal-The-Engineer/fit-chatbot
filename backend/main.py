from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
import uvicorn

from config import settings
from chatbot_service import ChatbotService

app = FastAPI(
    title="FitChat API",
    description="AI Fitness Assistant API with GPT and web search capabilities",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize chatbot service
chatbot_service = ChatbotService()

# Pydantic models
class ConversationMessage(BaseModel):
    role: str  # "user" or "assistant"
    content: str

class UserData(BaseModel):
    gender: str
    height: float  # cm
    weight: float  # kg
    age: int
    activity_level: str  # passive, normal, active

class ChatMessage(BaseModel):
    message: str
    language: Optional[str] = "tr"
    user_data: UserData
    conversation_history: Optional[List[ConversationMessage]] = []

class InitialMessageRequest(BaseModel):
    language: Optional[str] = "tr"

class ChatResponse(BaseModel):
    response: str
    is_initial: bool = False

@app.get("/")
async def root():
    return {"message": "FitChat API is running!"}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "FitChat API"}

@app.post("/chat", response_model=ChatResponse)
async def chat_endpoint(chat_message: ChatMessage):
    """
    Main chat endpoint that processes user messages and returns AI responses
    """
    try:
        # Convert UserData model to dictionary
        user_data_dict = {
            "gender": chat_message.user_data.gender,
            "height": chat_message.user_data.height,
            "weight": chat_message.user_data.weight,
            "age": chat_message.user_data.age,
            "activity_level": chat_message.user_data.activity_level
        }
        
        response = await chatbot_service.process_message(
            message=chat_message.message,
            user_data=user_data_dict,
            language=chat_message.language or "tr",
            conversation_history=chat_message.conversation_history or []
        )
        
        return ChatResponse(response=response)
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Chat processing error: {str(e)}")

@app.post("/chat/initial", response_model=ChatResponse)
async def get_initial_message(request: InitialMessageRequest):
    """
    Get the initial welcome message from the chatbot
    """
    try:
        initial_message = chatbot_service.get_initial_message(request.language or "tr")
        return ChatResponse(response=initial_message, is_initial=True)
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error getting initial message: {str(e)}")

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host=settings.HOST,
        port=settings.PORT,
        reload=settings.DEBUG
    ) 
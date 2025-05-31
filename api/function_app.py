import azure.functions as func
import json
import logging
import asyncio
from typing import Dict, Any, List, Optional
import os

# Backend kodlarını import et
from config import settings
from chatbot_service import ChatbotService

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

# Chatbot service'i initialize et
chatbot_service = ChatbotService()

@app.route(route="health", methods=["GET"])
def health_check(req: func.HttpRequest) -> func.HttpResponse:
    """Health check endpoint"""
    return func.HttpResponse(
        json.dumps({"status": "healthy", "service": "FitChat API", "message": "Azure Functions working!"}),
        status_code=200,
        headers={
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        }
    )

@app.route(route="test", methods=["GET", "POST", "OPTIONS"])
def test_endpoint(req: func.HttpRequest) -> func.HttpResponse:
    """Simple test endpoint"""
    
    headers = {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization"
    }
    
    if req.method == "OPTIONS":
        return func.HttpResponse("", status_code=200, headers=headers)
    
    return func.HttpResponse(
        json.dumps({
            "message": "Test endpoint working!",
            "method": req.method,
            "url": req.url,
            "env_vars": {
                "OPENAI_API_KEY": "SET" if os.environ.get("OPENAI_API_KEY") else "NOT_SET",
                "TAVILY_API_KEY": "SET" if os.environ.get("TAVILY_API_KEY") else "NOT_SET"
            }
        }),
        status_code=200,
        headers=headers
    )

@app.route(route="chat", methods=["POST", "OPTIONS"])
def chat_endpoint(req: func.HttpRequest) -> func.HttpResponse:
    """Simplified chat endpoint"""
    
    headers = {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization"
    }
    
    if req.method == "OPTIONS":
        return func.HttpResponse("", status_code=200, headers=headers)
    
    try:
        req_body = req.get_json()
        
        if not req_body:
            return func.HttpResponse(
                json.dumps({"error": "Request body is required"}),
                status_code=400,
                headers=headers
            )
        
        # Basit mock response
        message = req_body.get("message", "")
        language = req_body.get("language", "tr")
        
        if language == "tr":
            mock_response = f"Merhaba! '{message}' mesajınızı aldım. Bu bir test yanıtıdır. API çalışıyor!"
        else:
            mock_response = f"Hello! I received your message '{message}'. This is a test response. API is working!"
        
        return func.HttpResponse(
            json.dumps({"response": mock_response}),
            status_code=200,
            headers=headers
        )
        
    except Exception as e:
        logging.error(f"Chat error: {str(e)}")
        return func.HttpResponse(
            json.dumps({"error": f"Error: {str(e)}"}),
            status_code=500,
            headers=headers
        )

@app.route(route="chat/initial", methods=["POST", "OPTIONS"])
def initial_message_endpoint(req: func.HttpRequest) -> func.HttpResponse:
    """Get initial welcome message"""
    
    headers = {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization"
    }
    
    if req.method == "OPTIONS":
        return func.HttpResponse("", status_code=200, headers=headers)
    
    try:
        req_body = req.get_json() or {}
        language = req_body.get("language", "tr")
        
        if language == "tr":
            initial_message = "Merhaba! Ben FitChat asistanınızım. Size fitness konularında yardımcı olabilirim. (Test modu)"
        else:
            initial_message = "Hello! I'm your FitChat assistant. I can help you with fitness topics. (Test mode)"
        
        return func.HttpResponse(
            json.dumps({"response": initial_message, "is_initial": True}),
            status_code=200,
            headers=headers
        )
        
    except Exception as e:
        logging.error(f"Initial message error: {str(e)}")
        return func.HttpResponse(
            json.dumps({"error": f"Error: {str(e)}"}),
            status_code=500,
            headers=headers
        ) 
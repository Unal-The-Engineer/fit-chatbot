import azure.functions as func
import json
import logging
import asyncio
from typing import Dict, Any, List, Optional
import os

# Backend kodlarını import et
from .config import settings
from .chatbot_service import ChatbotService

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

# Chatbot service'i initialize et
chatbot_service = ChatbotService()

@app.route(route="health", methods=["GET"])
def health_check(req: func.HttpRequest) -> func.HttpResponse:
    """Health check endpoint"""
    return func.HttpResponse(
        json.dumps({"status": "healthy", "service": "FitChat API"}),
        status_code=200,
        headers={"Content-Type": "application/json"}
    )

@app.route(route="chat", methods=["POST", "OPTIONS"])
async def chat_endpoint(req: func.HttpRequest) -> func.HttpResponse:
    """Main chat endpoint"""
    
    # CORS headers
    headers = {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization"
    }
    
    # Handle OPTIONS request for CORS
    if req.method == "OPTIONS":
        return func.HttpResponse("", status_code=200, headers=headers)
    
    try:
        # Parse request body
        req_body = req.get_json()
        
        if not req_body:
            return func.HttpResponse(
                json.dumps({"error": "Request body is required"}),
                status_code=400,
                headers=headers
            )
        
        # Extract data
        message = req_body.get("message", "")
        language = req_body.get("language", "tr")
        user_data = req_body.get("user_data", {})
        conversation_history = req_body.get("conversation_history", [])
        
        if not message:
            return func.HttpResponse(
                json.dumps({"error": "Message is required"}),
                status_code=400,
                headers=headers
            )
        
        # Process message
        response = await chatbot_service.process_message(
            message=message,
            user_data=user_data,
            language=language,
            conversation_history=conversation_history
        )
        
        return func.HttpResponse(
            json.dumps({"response": response}),
            status_code=200,
            headers=headers
        )
        
    except Exception as e:
        logging.error(f"Chat processing error: {str(e)}")
        return func.HttpResponse(
            json.dumps({"error": f"Chat processing error: {str(e)}"}),
            status_code=500,
            headers=headers
        )

@app.route(route="chat/initial", methods=["POST", "OPTIONS"])
def initial_message_endpoint(req: func.HttpRequest) -> func.HttpResponse:
    """Get initial welcome message"""
    
    # CORS headers
    headers = {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization"
    }
    
    # Handle OPTIONS request for CORS
    if req.method == "OPTIONS":
        return func.HttpResponse("", status_code=200, headers=headers)
    
    try:
        # Parse request body
        req_body = req.get_json() or {}
        language = req_body.get("language", "tr")
        
        # Get initial message
        initial_message = chatbot_service.get_initial_message(language)
        
        return func.HttpResponse(
            json.dumps({"response": initial_message, "is_initial": True}),
            status_code=200,
            headers=headers
        )
        
    except Exception as e:
        logging.error(f"Initial message error: {str(e)}")
        return func.HttpResponse(
            json.dumps({"error": f"Error getting initial message: {str(e)}"}),
            status_code=500,
            headers=headers
        ) 
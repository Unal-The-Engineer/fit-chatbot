import azure.functions as func
import json
import logging
import os
import asyncio

# Backend kodlarını import et
try:
    from config import settings
    from chatbot_service import ChatbotService
    chatbot_service = ChatbotService()
    CHATBOT_AVAILABLE = True
except Exception as e:
    logging.error(f"Chatbot service import error: {e}")
    CHATBOT_AVAILABLE = False

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@app.route(route="health", methods=["GET"])
def health_check(req: func.HttpRequest) -> func.HttpResponse:
    """Health check endpoint"""
    logging.info('Health check endpoint called')
    
    return func.HttpResponse(
        json.dumps({
            "status": "healthy", 
            "service": "FitChat API", 
            "chatbot_available": CHATBOT_AVAILABLE,
            "openai_configured": bool(os.environ.get("OPENAI_API_KEY")),
            "tavily_configured": bool(os.environ.get("TAVILY_API_KEY"))
        }),
        status_code=200,
        headers={
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        }
    )

@app.route(route="test", methods=["GET", "POST", "OPTIONS"])
def test_endpoint(req: func.HttpRequest) -> func.HttpResponse:
    """Simple test endpoint"""
    logging.info(f'Test endpoint called with method: {req.method}')
    
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
            "url": str(req.url),
            "headers": dict(req.headers),
            "env_check": {
                "OPENAI_API_KEY": "SET" if os.environ.get("OPENAI_API_KEY") else "NOT_SET",
                "TAVILY_API_KEY": "SET" if os.environ.get("TAVILY_API_KEY") else "NOT_SET"
            }
        }),
        status_code=200,
        headers=headers
    )

@app.route(route="chat", methods=["POST", "OPTIONS"])
async def chat_endpoint(req: func.HttpRequest) -> func.HttpResponse:
    """Main chat endpoint"""
    logging.info(f'Chat endpoint called with method: {req.method}')
    
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
        
        # Gerçek chatbot kullan
        if CHATBOT_AVAILABLE:
            try:
                response = await chatbot_service.process_message(
                    message=message,
                    user_data=user_data,
                    language=language,
                    conversation_history=conversation_history
                )
            except Exception as e:
                logging.error(f"Chatbot service error: {e}")
                # Fallback response
                if language == "tr":
                    response = f"Üzgünüm, şu anda teknik bir sorun yaşıyorum. Lütfen daha sonra tekrar deneyin. Hata: {str(e)}"
                else:
                    response = f"Sorry, I'm experiencing a technical issue. Please try again later. Error: {str(e)}"
        else:
            # Fallback response when chatbot is not available
            if language == "tr":
                response = "Chatbot servisi şu anda kullanılamıyor. Lütfen daha sonra tekrar deneyin."
            else:
                response = "Chatbot service is currently unavailable. Please try again later."
        
        return func.HttpResponse(
            json.dumps({"response": response}),
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
    logging.info(f'Initial message endpoint called with method: {req.method}')
    
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
        
        # Gerçek chatbot kullan
        if CHATBOT_AVAILABLE:
            try:
                initial_message = chatbot_service.get_initial_message(language)
            except Exception as e:
                logging.error(f"Initial message service error: {e}")
                # Fallback message
                if language == "tr":
                    initial_message = "Merhaba! Ben FitChat asistanınızım. Size fitness konularında yardımcı olabilirim."
                else:
                    initial_message = "Hello! I'm your FitChat assistant. I can help you with fitness topics."
        else:
            # Fallback message when chatbot is not available
            if language == "tr":
                initial_message = "Merhaba! Ben FitChat asistanınızım. Size fitness konularında yardımcı olabilirim."
            else:
                initial_message = "Hello! I'm your FitChat assistant. I can help you with fitness topics."
        
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
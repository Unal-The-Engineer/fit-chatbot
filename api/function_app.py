import azure.functions as func
import json
import logging
import os

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@app.route(route="health", methods=["GET"])
def health_check(req: func.HttpRequest) -> func.HttpResponse:
    """Health check endpoint"""
    logging.info('Health check endpoint called')
    
    return func.HttpResponse(
        json.dumps({
            "status": "healthy", 
            "service": "FitChat API", 
            "message": "Azure Functions v2 working!",
            "timestamp": "2025-05-31"
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
def chat_endpoint(req: func.HttpRequest) -> func.HttpResponse:
    """Simplified chat endpoint"""
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
        
        # Mock response for testing
        message = req_body.get("message", "")
        language = req_body.get("language", "tr")
        
        if language == "tr":
            mock_response = f"Merhaba! '{message}' mesajınızı aldım. Bu bir test yanıtıdır. Azure Functions v2 çalışıyor!"
        else:
            mock_response = f"Hello! I received your message '{message}'. This is a test response. Azure Functions v2 is working!"
        
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
        
        if language == "tr":
            initial_message = "Merhaba! Ben FitChat asistanınızım. Size fitness konularında yardımcı olabilirim. (Azure Functions v2 Test Modu)"
        else:
            initial_message = "Hello! I'm your FitChat assistant. I can help you with fitness topics. (Azure Functions v2 Test Mode)"
        
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
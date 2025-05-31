import azure.functions as func
import logging
import json
import os
from typing import List, Optional

# Import our services
from config import settings
from chatbot_service import ChatbotService

# Initialize chatbot service
chatbot_service = ChatbotService()

async def main(req: func.HttpRequest) -> func.HttpResponse:
    """Azure Functions entry point"""
    logging.info('Python HTTP trigger function processed a request.')
    
    # Get the route from the request
    route = req.route_params.get('route', '')
    method = req.method
    
    try:
        # Health check endpoint
        if route == 'health' and method == 'GET':
            return func.HttpResponse(
                json.dumps({"status": "healthy", "service": "FitChat API"}),
                status_code=200,
                headers={"Content-Type": "application/json"}
            )
        
        # Initial chat message endpoint
        elif route == 'chat/initial' and method == 'POST':
            try:
                req_body = req.get_json()
                language = req_body.get('language', 'tr') if req_body else 'tr'
                
                initial_message = chatbot_service.get_initial_message(language)
                
                return func.HttpResponse(
                    json.dumps({
                        "response": initial_message,
                        "is_initial": True
                    }),
                    status_code=200,
                    headers={"Content-Type": "application/json"}
                )
            except Exception as e:
                logging.error(f"Error in initial chat: {str(e)}")
                return func.HttpResponse(
                    json.dumps({"error": f"Error getting initial message: {str(e)}"}),
                    status_code=500,
                    headers={"Content-Type": "application/json"}
                )
        
        # Main chat endpoint
        elif route == 'chat' and method == 'POST':
            try:
                req_body = req.get_json()
                if not req_body:
                    return func.HttpResponse(
                        json.dumps({"error": "Request body is required"}),
                        status_code=400,
                        headers={"Content-Type": "application/json"}
                    )
                
                message = req_body.get('message', '')
                language = req_body.get('language', 'tr')
                user_data = req_body.get('user_data', {})
                conversation_history = req_body.get('conversation_history', [])
                
                if not message:
                    return func.HttpResponse(
                        json.dumps({"error": "Message is required"}),
                        status_code=400,
                        headers={"Content-Type": "application/json"}
                    )
                
                # Convert user_data to the expected format
                user_data_dict = {
                    "gender": user_data.get("gender", "male"),
                    "height": user_data.get("height", 170),
                    "weight": user_data.get("weight", 70),
                    "age": user_data.get("age", 30),
                    "activity_level": user_data.get("activity_level", "normal")
                }
                
                response = await chatbot_service.process_message(
                    message=message,
                    user_data=user_data_dict,
                    language=language,
                    conversation_history=conversation_history
                )
                
                return func.HttpResponse(
                    json.dumps({"response": response}),
                    status_code=200,
                    headers={"Content-Type": "application/json"}
                )
                
            except Exception as e:
                logging.error(f"Error in chat: {str(e)}")
                return func.HttpResponse(
                    json.dumps({"error": f"Chat processing error: {str(e)}"}),
                    status_code=500,
                    headers={"Content-Type": "application/json"}
                )
        
        # Handle OPTIONS requests for CORS
        elif method == 'OPTIONS':
            return func.HttpResponse(
                "",
                status_code=200,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
                    "Access-Control-Allow-Headers": "Content-Type, Authorization"
                }
            )
        
        # Route not found
        else:
            return func.HttpResponse(
                json.dumps({"error": f"Route not found: {route}"}),
                status_code=404,
                headers={"Content-Type": "application/json"}
            )
            
    except Exception as e:
        logging.error(f"Unexpected error: {str(e)}")
        return func.HttpResponse(
            json.dumps({"error": f"Internal server error: {str(e)}"}),
            status_code=500,
            headers={"Content-Type": "application/json"}
        ) 
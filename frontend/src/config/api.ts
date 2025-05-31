// API Configuration
export const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 
  (import.meta.env.PROD ? '/api' : 'http://localhost:8000');
 
export const API_ENDPOINTS = {
  CHAT: `${API_BASE_URL}/chat`,
  CHAT_INITIAL: `${API_BASE_URL}/chat/initial`,
  HEALTH: `${API_BASE_URL}/health`,
} as const; 
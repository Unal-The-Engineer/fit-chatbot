import React, { useState, useRef, useEffect } from 'react';
import { Send, Bot, Target, TrendingUp, TrendingDown, Minus, UtensilsCrossed } from 'lucide-react';
import { useUserData } from '../context/UserDataContext';
import { useLanguage } from '../context/LanguageContext';
import ChatMessage from './chat/ChatMessage';
import { Message, MessageType } from '../types/chat';
import { API_ENDPOINTS } from '../config/api';

const ChatbotPanel: React.FC = () => {
  const { userData } = useUserData();
  const { t, language } = useLanguage();
  const [messages, setMessages] = useState<Message[]>([]);
  const [inputValue, setInputValue] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const [isInitialized, setIsInitialized] = useState(false);
  const [showQuickActions, setShowQuickActions] = useState(false);
  const [showNutritionAction, setShowNutritionAction] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  
  // Initialize chat with welcome message
  useEffect(() => {
    if (!isInitialized) {
      initializeChat();
    }
  }, [isInitialized]);

  // Re-initialize when language changes
  useEffect(() => {
    if (isInitialized) {
      setIsInitialized(false);
      setMessages([]);
      setShowQuickActions(false);
      setShowNutritionAction(false);
    }
  }, [language]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const initializeChat = async () => {
    try {
      const response = await fetch(API_ENDPOINTS.CHAT_INITIAL, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          language: language
        }),
      });

      if (response.ok) {
        const data = await response.json();
        const initialMessage: Message = {
          id: '1',
          type: MessageType.BOT,
          text: data.response,
          timestamp: new Date(),
        };
        setMessages([initialMessage]);
        setIsInitialized(true);
        setShowQuickActions(true);
      }
    } catch (error) {
      console.error('Failed to initialize chat:', error);
      // Fallback message based on language
      const fallbackText = language === 'tr' 
        ? 'Merhaba! Ben senin profesyonel beslenme asistanın FitChat. Bilgilerinize göre kişiselleştirilmiş beslenme planı hazırlayabilirim. Hedefinizi öğrenebilir miyim? Kilo vermek, almak yoksa mevcut kilonuzu korumak mı istiyorsunuz?'
        : 'Hello! I am your professional nutrition assistant FitChat. I can prepare personalized nutrition plans based on your information. Can I learn about your goal? Do you want to lose weight, gain weight, or maintain your current weight?';
        
      const fallbackMessage: Message = {
        id: '1',
        type: MessageType.BOT,
        text: fallbackText,
        timestamp: new Date(),
      };
      setMessages([fallbackMessage]);
      setIsInitialized(true);
      setShowQuickActions(true);
    }
  };

  const handleQuickAction = async (actionText: string) => {
    setShowQuickActions(false);
    
    const userMessage: Message = {
      id: Date.now().toString(),
      type: MessageType.USER,
      text: actionText,
      timestamp: new Date(),
    };
    
    setMessages(prev => [...prev, userMessage]);
    await sendMessage(actionText);
    
    // İkinci mesajdan sonra beslenme programı butonunu göster
    setShowNutritionAction(true);
  };

  const handleNutritionAction = async () => {
    setShowNutritionAction(false);
    
    const nutritionText = language === 'tr' 
      ? 'Beslenme programı oluşturmak istiyorum'
      : 'I want to create a nutrition program';
    
    const userMessage: Message = {
      id: Date.now().toString(),
      type: MessageType.USER,
      text: nutritionText,
      timestamp: new Date(),
    };
    
    setMessages(prev => [...prev, userMessage]);
    await sendMessage(nutritionText);
  };
  
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setInputValue(e.target.value);
  };
  
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!inputValue.trim()) return;
    
    const userMessage: Message = {
      id: Date.now().toString(),
      type: MessageType.USER,
      text: inputValue,
      timestamp: new Date(),
    };
    
    setMessages(prev => [...prev, userMessage]);
    const messageText = inputValue;
    setInputValue('');
    
    // Quick actions'ları gizle
    setShowQuickActions(false);
    setShowNutritionAction(false);
    
    await sendMessage(messageText);
  };

  const sendMessage = async (messageText: string) => {
    setIsTyping(true);
    
    try {
      // Convert messages to conversation history format
      const conversationHistory = messages.map(msg => ({
        role: msg.type === MessageType.BOT ? 'assistant' : 'user',
        content: msg.text
      }));

      const response = await fetch(API_ENDPOINTS.CHAT, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          message: messageText,
          language: language,
          conversation_history: conversationHistory,
          user_data: {
            gender: userData.gender,
            height: userData.height,
            weight: userData.weight,
            age: userData.age,
            activity_level: userData.activityLevel
          }
        }),
      });

      if (response.ok) {
        const data = await response.json();
        const botMessage: Message = {
          id: (Date.now() + 1).toString(),
          type: MessageType.BOT,
          text: data.response,
          timestamp: new Date(),
        };
        
        setMessages(prev => [...prev, botMessage]);
      } else {
        throw new Error('API request failed');
      }
    } catch (error) {
      console.error('Chat error:', error);
      const errorText = language === 'tr' 
        ? 'Üzgünüm, bir hata oluştu. Lütfen tekrar deneyin.'
        : 'Sorry, an error occurred. Please try again.';
        
      const errorMessage: Message = {
        id: (Date.now() + 1).toString(),
        type: MessageType.BOT,
        text: errorText,
        timestamp: new Date(),
      };
      setMessages(prev => [...prev, errorMessage]);
    } finally {
      setIsTyping(false);
    }
  };

  const quickActions = [
    {
      text: language === 'tr' ? 'Kilo vermek istiyorum' : 'I want to lose weight',
      icon: TrendingDown,
      color: 'bg-red-500 hover:bg-red-600'
    },
    {
      text: language === 'tr' ? 'Kilo almak istiyorum' : 'I want to gain weight',
      icon: TrendingUp,
      color: 'bg-green-500 hover:bg-green-600'
    },
    {
      text: language === 'tr' ? 'Kilomu korumak istiyorum' : 'I want to maintain my weight',
      icon: Minus,
      color: 'bg-blue-500 hover:bg-blue-600'
    }
  ];
  
  return (
    <div className="w-full lg:w-1/2 bg-white rounded-xl shadow-sm p-6 transition-all duration-300 card-hover">
      <h2 className="text-xl font-semibold text-gray-800 mb-4 flex items-center">
        <Bot className="w-5 h-5 mr-2 text-blue-500" />
        {t('fitchatAssistant')}
      </h2>
      
      <div className="flex-1 overflow-y-auto mb-4 space-y-4 pr-2 h-[450px]">
        {messages.map(message => (
          <div key={message.id} className="message-animation">
            <ChatMessage message={message} />
          </div>
        ))}
        
        {/* Quick Action Buttons - Hedef Seçimi */}
        {showQuickActions && (
          <div className="message-animation">
            <div className="flex flex-wrap gap-2 mt-4">
              {quickActions.map((action, index) => {
                const IconComponent = action.icon;
                return (
                  <button
                    key={index}
                    onClick={() => handleQuickAction(action.text)}
                    className={`flex items-center space-x-2 px-4 py-2 rounded-full text-white text-sm font-medium transition-all duration-200 transform hover:scale-105 ${action.color}`}
                  >
                    <IconComponent className="w-4 h-4" />
                    <span>{action.text}</span>
                  </button>
                );
              })}
            </div>
          </div>
        )}

        {/* Nutrition Program Button */}
        {showNutritionAction && (
          <div className="message-animation">
            <div className="flex justify-center mt-4">
              <button
                onClick={handleNutritionAction}
                className="flex items-center space-x-2 px-6 py-3 bg-orange-500 hover:bg-orange-600 text-white rounded-full font-medium transition-all duration-200 transform hover:scale-105 shadow-lg"
              >
                <UtensilsCrossed className="w-5 h-5" />
                <span>
                  {language === 'tr' ? 'Beslenme Programı Oluştur' : 'Create Nutrition Program'}
                </span>
              </button>
            </div>
          </div>
        )}
        
        {isTyping && (
          <div className="flex items-center space-x-2 text-gray-500 text-sm message-animation">
            <div className="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center">
              <Bot className="w-5 h-5 text-blue-500" />
            </div>
            <div className="typing-indicator">
              <span></span>
              <span></span>
              <span></span>
            </div>
          </div>
        )}
        
        <div ref={messagesEndRef} />
      </div>
      
      <form onSubmit={handleSubmit} className="mt-auto">
        <div className="relative">
          <input
            type="text"
            value={inputValue}
            onChange={handleInputChange}
            placeholder={t('typeYourMessage')}
            className="w-full pl-4 pr-12 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
          />
          <button
            type="submit"
            className={`absolute right-2 top-1/2 transform -translate-y-1/2 w-8 h-8 flex items-center justify-center bg-blue-500 text-white rounded-full hover:bg-blue-600 transition-colors ${
              inputValue.trim() ? 'pulse-effect' : ''
            }`}
            disabled={!inputValue.trim() || isTyping}
          >
            <Send className="w-4 h-4" />
          </button>
        </div>
      </form>
    </div>
  );
};

// Simple bot response generator
function generateBotResponse(userInput: string, userData: any): string {
  const input = userInput.toLowerCase();
  
  if (input.includes('bmi') || input.includes('body mass index')) {
    const height = userData.height / 100; // convert to meters
    const bmi = (userData.weight / (height * height)).toFixed(1);
    return `Based on your height (${userData.height}cm) and weight (${userData.weight}kg), your BMI is ${bmi}. ${interpretBMI(parseFloat(bmi))}`;
  }
  
  if (input.includes('calorie') || input.includes('calories')) {
    return `Based on your ${userData.gender} profile, height of ${userData.height}cm, weight of ${userData.weight}kg, and ${userData.activityLevel} activity level, your estimated daily calorie needs are around ${calculateCalories(userData)}kcal.`;
  }
  
  if (input.includes('exercise') || input.includes('workout')) {
    if (userData.activityLevel === 'passive') {
      return 'Since you have a passive activity level, I recommend starting with light exercises like walking, gentle yoga, or swimming. Aim for 20-30 minutes, 3 times a week, and gradually increase as your fitness improves.';
    } else if (userData.activityLevel === 'normal') {
      return 'With your normal activity level, you could benefit from a mix of cardio and strength training. Try 30 minutes of moderate cardio 3 times a week, plus 2 strength sessions.';
    } else {
      return 'Given your active lifestyle, consider adding high-intensity interval training (HIIT) to your routine, along with regular strength training 3-4 times a week to maximize your fitness gains.';
    }
  }
  
  return "I'm here to help with fitness and nutrition advice based on your profile. Feel free to ask about BMI, calorie needs, or exercise recommendations!";
}

function interpretBMI(bmi: number): string {
  if (bmi < 18.5) return "This is considered underweight.";
  if (bmi < 25) return "This is within the healthy weight range.";
  if (bmi < 30) return "This is considered overweight.";
  return "This is in the obese range.";
}

function calculateCalories(userData: any): number {
  const { gender, weight, height, activityLevel } = userData;
  
  // Basic BMR calculation using Mifflin-St Jeor Equation
  let bmr = 0;
  if (gender === 'male') {
    bmr = 10 * weight + 6.25 * height - 5 * 30 + 5; // Assuming age 30
  } else {
    bmr = 10 * weight + 6.25 * height - 5 * 30 - 161; // Assuming age 30
  }
  
  // Activity multiplier
  const multipliers = {
    passive: 1.2,
    normal: 1.55,
    active: 1.725
  };
  
  return Math.round(bmr * multipliers[activityLevel as keyof typeof multipliers]);
}

export default ChatbotPanel;
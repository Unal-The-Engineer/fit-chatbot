import React from 'react';
import { Bot, User } from 'lucide-react';
import ReactMarkdown from 'react-markdown';
import { Message, MessageType } from '../../types/chat';

interface ChatMessageProps {
  message: Message;
}

const ChatMessage: React.FC<ChatMessageProps> = ({ message }) => {
  const isBot = message.type === MessageType.BOT;
  
  return (
    <div className={`flex ${isBot ? 'justify-start' : 'justify-end'}`}>
      <div className={`flex max-w-[85%] ${isBot ? 'flex-row' : 'flex-row-reverse'}`}>
        <div className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${
          isBot ? 'bg-blue-100 mr-3' : 'bg-gray-100 ml-3'
        }`}>
          {isBot ? (
            <Bot className="w-5 h-5 text-blue-500" />
          ) : (
            <User className="w-5 h-5 text-gray-500" />
          )}
        </div>
        
        <div className={`rounded-2xl px-4 py-3 ${
          isBot 
            ? 'bg-blue-50 text-gray-800 rounded-tl-none' 
            : 'bg-blue-500 text-white rounded-tr-none'
        }`}>
          {isBot ? (
            <div className="prose prose-sm max-w-none">
              <ReactMarkdown
                components={{
                  h2: ({ children }) => (
                    <h2 className="text-lg font-semibold text-gray-800 mb-2 mt-1">{children}</h2>
                  ),
                  h3: ({ children }) => (
                    <h3 className="text-md font-medium text-gray-700 mb-2 mt-3">{children}</h3>
                  ),
                  p: ({ children }) => (
                    <p className="text-sm text-gray-700 mb-2">{children}</p>
                  ),
                  ul: ({ children }) => (
                    <ul className="list-disc list-inside space-y-1 mb-2">{children}</ul>
                  ),
                  li: ({ children }) => (
                    <li className="text-sm text-gray-700">{children}</li>
                  ),
                  strong: ({ children }) => (
                    <strong className="font-semibold text-gray-800">{children}</strong>
                  ),
                }}
              >
                {message.text}
              </ReactMarkdown>
            </div>
          ) : (
            <p className="text-sm">{message.text}</p>
          )}
          <p className={`text-xs mt-2 ${isBot ? 'text-gray-500' : 'text-blue-100'}`}>
            {formatTimestamp(message.timestamp)}
          </p>
        </div>
      </div>
    </div>
  );
};

function formatTimestamp(date: Date): string {
  return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}

export default ChatMessage;
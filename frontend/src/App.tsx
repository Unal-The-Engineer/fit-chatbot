import React from 'react';
import UserInputPanel from './components/UserInputPanel';
import ChatbotPanel from './components/ChatbotPanel';
import LanguageSwitcher from './components/LanguageSwitcher';
import { UserDataProvider } from './context/UserDataContext';
import { LanguageProvider, useLanguage } from './context/LanguageContext';

function AppContent() {
  const { t } = useLanguage();
  
  return (
    <div className="animated-bg">
      <div className="container mx-auto p-4 min-h-screen">
        <header className="mb-8 text-center pt-6 relative">
          <div className="absolute top-0 right-0">
            <LanguageSwitcher />
          </div>
          <h1 className="text-3xl font-bold text-white">{t('appTitle')}</h1>
          <p className="text-white/80 mt-2">{t('appSubtitle')}</p>
        </header>
        
        <UserDataProvider>
          <main className="flex flex-col lg:flex-row gap-6">
            <UserInputPanel />
            <ChatbotPanel />
          </main>
        </UserDataProvider>
        
        <footer className="mt-12 text-center text-sm text-white/70 pb-6">
          © {new Date().getFullYear()} {t('footerText')}
        </footer>
      </div>
    </div>
  );
}

function App() {
  return (
    <LanguageProvider>
      <AppContent />
    </LanguageProvider>
  );
}

export default App
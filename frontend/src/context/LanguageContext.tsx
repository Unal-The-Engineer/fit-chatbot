import React, { createContext, useState, useContext, ReactNode } from 'react';

export type Language = 'tr' | 'en';

interface LanguageContextType {
  language: Language;
  setLanguage: (lang: Language) => void;
  t: (key: string) => string;
}

const translations = {
  tr: {
    // Header
    appTitle: 'FitChat Assistant',
    appSubtitle: 'Fitness verilerinizi takip edin ve kişiselleştirilmiş tavsiyeler alın',
    
    // User Input Panel
    yourInformation: 'Bilgileriniz',
    gender: 'Cinsiyet',
    male: 'Erkek',
    female: 'Kadın',
    other: 'Diğer',
    age: 'Yaş',
    height: 'Boy',
    weight: 'Kilo',
    activityLevel: 'Aktivite Seviyesi',
    passive: 'Pasif',
    normal: 'Normal',
    active: 'Aktif',
    profileSummary: 'Profil Özeti',
    
    // Activity Level descriptions
    passiveDesc: 'Az ya da hiç egzersiz yok, masa başı iş',
    normalDesc: 'Haftada 1-3 kez hafif egzersiz',
    activeDesc: 'Haftada 3-5 kez orta düzeyde egzersiz',
    
    // Age categories
    youngAdult: 'Genç Yetişkin',
    adult: 'Yetişkin',
    middleAge: 'Orta Yaş',
    senior: 'Yaşlı',
    
    // Chat Panel
    fitchatAssistant: 'FitChat Assistant',
    typeYourMessage: 'Mesajınızı yazın...',
    
    // Footer
    footerText: 'FitChat Assistant. Tüm hakları saklıdır.',
    
    // Units
    yearsOld: 'yaş',
    cm: 'cm',
    kg: 'kg',
  },
  en: {
    // Header
    appTitle: 'FitChat Assistant',
    appSubtitle: 'Track your fitness metrics and get personalized advice',
    
    // User Input Panel
    yourInformation: 'Your Information',
    gender: 'Gender',
    male: 'Male',
    female: 'Female',
    other: 'Other',
    age: 'Age',
    height: 'Height',
    weight: 'Weight',
    activityLevel: 'Activity Level',
    passive: 'Passive',
    normal: 'Normal',
    active: 'Active',
    profileSummary: 'Your Profile Summary',
    
    // Activity Level descriptions
    passiveDesc: 'Little to no regular exercise, desk job',
    normalDesc: 'Light exercise 1-3 times a week',
    activeDesc: 'Moderate exercise 3-5 times a week',
    
    // Age categories
    youngAdult: 'Young Adult',
    adult: 'Adult',
    middleAge: 'Middle Age',
    senior: 'Senior',
    
    // Chat Panel
    fitchatAssistant: 'FitChat Assistant',
    typeYourMessage: 'Type your message...',
    
    // Footer
    footerText: 'FitChat Assistant. All rights reserved.',
    
    // Units
    yearsOld: 'years old',
    cm: 'cm',
    kg: 'kg',
  }
};

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [language, setLanguage] = useState<Language>('tr');

  const t = (key: string): string => {
    return translations[language][key as keyof typeof translations[typeof language]] || key;
  };

  return (
    <LanguageContext.Provider value={{ language, setLanguage, t }}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
} 
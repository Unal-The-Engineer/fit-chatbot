import React, { useState } from 'react';
import { ActivitySquare, ChevronDown, ChevronUp } from 'lucide-react';
import { useUserData, ActivityLevel } from '../../context/UserDataContext';
import { useLanguage } from '../../context/LanguageContext';

const ActivityLevelDropdown: React.FC = () => {
  const { userData, updateUserData } = useUserData();
  const { t } = useLanguage();
  const [isOpen, setIsOpen] = useState(false);
  
  const activityOptions: { value: ActivityLevel; label: string; description: string }[] = [
    { 
      value: 'passive', 
      label: t('passive'), 
      description: t('passiveDesc') 
    },
    { 
      value: 'normal', 
      label: t('normal'), 
      description: t('normalDesc') 
    },
    { 
      value: 'active', 
      label: t('active'), 
      description: t('activeDesc') 
    },
  ];
  
  const handleSelect = (activityLevel: ActivityLevel) => {
    updateUserData({ activityLevel });
    setIsOpen(false);
  };
  
  const selectedOption = activityOptions.find(option => option.value === userData.activityLevel);
  
  return (
    <div className="space-y-2">
      <label htmlFor="activityLevel" className="block text-sm font-medium text-gray-700">
        {t('activityLevel')}
      </label>
      <div className="relative">
        <button
          type="button"
          className="w-full flex items-center justify-between px-4 py-2.5 bg-white border border-gray-300 rounded-lg text-left text-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          onClick={() => setIsOpen(!isOpen)}
          aria-haspopup="listbox"
          aria-expanded={isOpen}
        >
          <div className="flex items-center">
            <ActivitySquare className="h-5 w-5 mr-2 text-blue-500" />
            <span>{selectedOption?.label}</span>
          </div>
          {isOpen ? (
            <ChevronUp className="h-5 w-5 text-gray-400" />
          ) : (
            <ChevronDown className="h-5 w-5 text-gray-400" />
          )}
        </button>
        
        {isOpen && (
          <div className="absolute z-10 mt-1 w-full bg-white shadow-lg rounded-lg border border-gray-200 overflow-hidden">
            <ul className="py-1 max-h-60 overflow-auto" role="listbox">
              {activityOptions.map((option) => (
                <li
                  key={option.value}
                  className={`px-4 py-2.5 cursor-pointer hover:bg-blue-50 ${
                    option.value === userData.activityLevel ? 'bg-blue-50 text-blue-700' : 'text-gray-700'
                  }`}
                  role="option"
                  aria-selected={option.value === userData.activityLevel}
                  onClick={() => handleSelect(option.value)}
                >
                  <div className="font-medium">{option.label}</div>
                  <div className="text-sm text-gray-500">{option.description}</div>
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>
    </div>
  );
};

export default ActivityLevelDropdown;
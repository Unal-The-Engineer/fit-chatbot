import React, { useState } from 'react';
import { Calendar, ChevronDown, ChevronUp } from 'lucide-react';
import { useUserData } from '../../context/UserDataContext';
import { useLanguage } from '../../context/LanguageContext';

// Generate age options from 16 to 80
const generateAgeOptions = (t: (key: string) => string) => {
  const options = [];
  for (let age = 16; age <= 80; age++) {
    let category = '';
    if (age >= 16 && age <= 25) category = t('youngAdult');
    else if (age >= 26 && age <= 40) category = t('adult');
    else if (age >= 41 && age <= 60) category = t('middleAge');
    else category = t('senior');
    
    options.push({
      value: age,
      label: `${age} ${t('yearsOld')}`,
      category: category
    });
  }
  return options;
};

const AgeDropdown: React.FC = () => {
  const { userData, updateUserData } = useUserData();
  const { t } = useLanguage();
  const [isOpen, setIsOpen] = useState(false);
  
  const ageOptions = generateAgeOptions(t);
  
  const handleSelect = (age: number) => {
    updateUserData({ age });
    setIsOpen(false);
  };
  
  const selectedOption = ageOptions.find(option => option.value === userData.age);
  
  return (
    <div className="space-y-2">
      <label htmlFor="age" className="block text-sm font-medium text-gray-700">
        {t('age')}
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
            <Calendar className="h-5 w-5 mr-2 text-blue-500" />
            <span>{selectedOption?.label || `${userData.age} ${t('yearsOld')}`}</span>
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
              {ageOptions.map((option) => (
                <li
                  key={option.value}
                  className={`px-4 py-2.5 cursor-pointer hover:bg-blue-50 ${
                    option.value === userData.age ? 'bg-blue-50 text-blue-700' : 'text-gray-700'
                  }`}
                  role="option"
                  aria-selected={option.value === userData.age}
                  onClick={() => handleSelect(option.value)}
                >
                  <div className="font-medium">{option.label}</div>
                  <div className="text-sm text-gray-500">{option.category}</div>
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>
    </div>
  );
};

export default AgeDropdown; 
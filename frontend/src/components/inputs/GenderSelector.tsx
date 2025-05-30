import React from 'react';
import { Scale as Male, Scale as Female, User } from 'lucide-react';
import { useUserData, Gender } from '../../context/UserDataContext';
import { useLanguage } from '../../context/LanguageContext';

const GenderSelector: React.FC = () => {
  const { userData, updateUserData } = useUserData();
  const { t } = useLanguage();
  
  const handleGenderChange = (gender: Gender) => {
    updateUserData({ gender });
  };
  
  return (
    <div className="space-y-2">
      <label htmlFor="gender" className="block text-sm font-medium text-gray-700">
        {t('gender')}
      </label>
      <div className="flex space-x-2">
        <button
          type="button"
          onClick={() => handleGenderChange('male')}
          className={`flex items-center justify-center px-4 py-2 rounded-lg transition-all ${
            userData.gender === 'male'
              ? 'bg-blue-500 text-white'
              : 'bg-gray-100 hover:bg-gray-200 text-gray-700'
          }`}
        >
          <Male className="mr-2 h-5 w-5" />
          {t('male')}
        </button>
        <button
          type="button"
          onClick={() => handleGenderChange('female')}
          className={`flex items-center justify-center px-4 py-2 rounded-lg transition-all ${
            userData.gender === 'female'
              ? 'bg-blue-500 text-white'
              : 'bg-gray-100 hover:bg-gray-200 text-gray-700'
          }`}
        >
          <Female className="mr-2 h-5 w-5" />
          {t('female')}
        </button>
        <button
          type="button"
          onClick={() => handleGenderChange('other')}
          className={`flex items-center justify-center px-4 py-2 rounded-lg transition-all ${
            userData.gender === 'other'
              ? 'bg-blue-500 text-white'
              : 'bg-gray-100 hover:bg-gray-200 text-gray-700'
          }`}
        >
          <User className="mr-2 h-5 w-5" />
          {t('other')}
        </button>
      </div>
    </div>
  );
};

export default GenderSelector;
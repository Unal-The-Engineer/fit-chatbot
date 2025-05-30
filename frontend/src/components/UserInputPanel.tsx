import React from 'react';
import { useUserData } from '../context/UserDataContext';
import { useLanguage } from '../context/LanguageContext';
import GenderSelector from './inputs/GenderSelector';
import SliderInput from './inputs/SliderInput';
import ActivityLevelDropdown from './inputs/ActivityLevelDropdown';
import AgeDropdown from './inputs/AgeDropdown';

const UserInputPanel: React.FC = () => {
  const { userData } = useUserData();
  const { t } = useLanguage();

  return (
    <div className="w-full lg:w-1/2 bg-white rounded-xl shadow-sm p-6 transition-all duration-300 card-hover">
      <h2 className="text-xl font-semibold text-gray-800 mb-6">{t('yourInformation')}</h2>
      
      <div className="space-y-6">
        <GenderSelector />
        
        <AgeDropdown />
        
        <SliderInput 
          label={t('height')}
          id="height"
          min={100}
          max={220}
          value={userData.height}
          unit={t('cm')}
          step={1}
        />
        
        <SliderInput 
          label={t('weight')}
          id="weight"
          min={30}
          max={200}
          value={userData.weight}
          unit={t('kg')}
          step={0.5}
        />
        
        <ActivityLevelDropdown />
      </div>
      
      <div className="mt-8 p-4 bg-blue-50 rounded-lg transform transition-all duration-300 hover:scale-[1.02]">
        <h3 className="text-md font-medium text-blue-700 mb-2">{t('profileSummary')}</h3>
        <div className="text-sm text-gray-600 space-y-1">
          <p>{t('gender')}: {t(userData.gender)}</p>
          <p>{t('age')}: {userData.age} {t('yearsOld')}</p>
          <p>{t('height')}: {userData.height} {t('cm')}</p>
          <p>{t('weight')}: {userData.weight} {t('kg')}</p>
          <p>{t('activityLevel')}: {t(userData.activityLevel)}</p>
        </div>
      </div>
    </div>
  );
};

export default UserInputPanel;
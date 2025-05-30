import React, { createContext, useState, useContext, ReactNode } from 'react';

export type Gender = 'male' | 'female' | 'other';
export type ActivityLevel = 'passive' | 'normal' | 'active';

export interface UserData {
  gender: Gender;
  height: number;
  weight: number;
  age: number;
  activityLevel: ActivityLevel;
}

interface UserDataContextType {
  userData: UserData;
  updateUserData: (newData: Partial<UserData>) => void;
}

const defaultUserData: UserData = {
  gender: 'male',
  height: 170,
  weight: 70,
  age: 30,
  activityLevel: 'normal',
};

const UserDataContext = createContext<UserDataContextType | undefined>(undefined);

export function UserDataProvider({ children }: { children: ReactNode }) {
  const [userData, setUserData] = useState<UserData>(defaultUserData);

  const updateUserData = (newData: Partial<UserData>) => {
    setUserData(prevData => ({
      ...prevData,
      ...newData,
    }));
  };

  return (
    <UserDataContext.Provider value={{ userData, updateUserData }}>
      {children}
    </UserDataContext.Provider>
  );
}

export function useUserData() {
  const context = useContext(UserDataContext);
  if (context === undefined) {
    throw new Error('useUserData must be used within a UserDataProvider');
  }
  return context;
}
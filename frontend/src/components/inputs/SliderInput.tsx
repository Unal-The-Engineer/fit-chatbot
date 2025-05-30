import React, { useState, useEffect } from 'react';
import { useUserData } from '../../context/UserDataContext';

interface SliderInputProps {
  label: string;
  id: 'height' | 'weight';
  min: number;
  max: number;
  value: number;
  unit: string;
  step: number;
}

const SliderInput: React.FC<SliderInputProps> = ({
  label,
  id,
  min,
  max,
  value,
  unit,
  step
}) => {
  const { updateUserData } = useUserData();
  const [localValue, setLocalValue] = useState(value);
  
  useEffect(() => {
    setLocalValue(value);
  }, [value]);
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = parseFloat(e.target.value);
    setLocalValue(newValue);
  };
  
  const handleChangeCommitted = () => {
    updateUserData({ [id]: localValue });
  };
  
  // Calculate the percentage for the gradient background
  const percentage = ((localValue - min) / (max - min)) * 100;
  
  return (
    <div className="space-y-2">
      <div className="flex justify-between">
        <label htmlFor={id} className="block text-sm font-medium text-gray-700">
          {label}
        </label>
        <span className="text-sm font-medium text-blue-600">
          {localValue} {unit}
        </span>
      </div>
      <div className="relative">
        <input
          type="range"
          id={id}
          min={min}
          max={max}
          step={step}
          value={localValue}
          onChange={handleChange}
          onMouseUp={handleChangeCommitted}
          onTouchEnd={handleChangeCommitted}
          className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer"
          style={{
            background: `linear-gradient(to right, #3B82F6 0%, #3B82F6 ${percentage}%, #e5e7eb ${percentage}%, #e5e7eb 100%)`
          }}
        />
        <div className="mt-1.5 flex justify-between text-xs text-gray-500">
          <span>{min} {unit}</span>
          <span>{max} {unit}</span>
        </div>
      </div>
    </div>
  );
};

export default SliderInput;
// src/utils/locale.ts

let translations: Record<string, string> = {};

export const setTranslations = (data: Record<string, string>) => {
  translations = data;
};

export const locale = (key: string): string => {
  return translations[key] || key;
};
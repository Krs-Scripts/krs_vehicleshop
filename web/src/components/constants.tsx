import React from "react";

export const categoryLabels: Record<string, string> = {
  compacts: "Compacts",
  motorcycles: "Motos",
  muscle: "Muscle",
  sedans: "Sedans",
  sports: "Sports",
  super: "Super",
  vans: "Vans",
  boats: "Barche",    
  planes: "Aerei",       
  helicopters: "Elicotteri" 
};

export type Rgb = { r: number; g: number; b: number };

export const DEFAULT_SWATCHES: Rgb[] = [

  { r: 255, g: 255, b: 255 }, // #ffffff - White
  { r: 3, g: 3, b: 3 },       // #030303 - Black
  { r: 218, g: 218, b: 218 }, // #dadada - Light Gray
  { r: 201, g: 255, b: 7 },   // #c9ff07 - Acid Yellow/Green

  { r: 157, g: 255, b: 0 },   // #9dff00 - Lime
  { r: 244, g: 54, b: 70 },   // #f43646 - Red
  { r: 33, g: 150, b: 243 },  // #2196F3 - Blue
  { r: 255, g: 43, b: 131 },  // #ff2b83 - Magenta/Pink

  { r: 255, g: 174, b: 0 },   // #ffae00 - Orange
  { r: 63, g: 81, b: 181 },   // #3F51B5 - Indigo / Dark Blue
];


export const rgbToCss = (c: Rgb) => `rgb(${c.r}, ${c.g}, ${c.b})`;
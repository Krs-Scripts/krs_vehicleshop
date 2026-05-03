import { Box, Stack, Text, ScrollArea, Group, rem, TextInput, Image } from "@mantine/core";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faSearch } from "@fortawesome/free-solid-svg-icons";
import { FaCar, FaMotorcycle, FaTruck, FaPlane, FaHelicopter, FaShip } from "react-icons/fa";

const THEME = {
  blue: "#228be6", 
};

interface Props {
  vehicles: any[];
  categories: string[];
  search: string;
  setSearch: (val: string) => void;
  selectedCategory: string | null;
  onSelectCategory: (cat: string | null) => void;
  selectedVehicle: any | null;
  onPreview: (v: any) => void;
  placeholderText: string; 
}

const CategoryIcon = ({ category, isSelected }: { category: string, isSelected: boolean }) => {
  const cat = category.toLowerCase();
  const iconSize = 18; 
  const color = isSelected ? "white" : "rgba(255, 255, 255, 0.7)";
  const iconProps = { size: iconSize, color: color };

  if (cat.includes("moto")) return <FaMotorcycle {...iconProps} />;
  if (cat.includes("van") || cat.includes("commercial")) return <FaTruck {...iconProps} />;
  if (cat.includes("plane") || cat.includes("aerei")) return <FaPlane {...iconProps} />;
  if (cat.includes("heli") || cat.includes("elicotteri")) return <FaHelicopter {...iconProps} />;
  if (cat.includes("boat") || cat.includes("barche")) return <FaShip {...iconProps} />;
  return <FaCar {...iconProps} />; 
};

export const VehicleBrowser = ({ 
  vehicles, 
  categories,
  search, 
  setSearch, 
  selectedCategory, 
  onSelectCategory, 
  selectedVehicle, 
  onPreview, 
  placeholderText 
}: Props) => {
  return (
    <Box
      pos="absolute"
      right={rem(40)} 
      top="52%" 
      w={rem(320)} 
      style={{
        transform: "translateY(-50%) perspective(1200px) rotateY(-15deg) skewY(1deg) translateZ(0)",
        transformOrigin: "right center",
        transformStyle: "preserve-3d",
        WebkitFontSmoothing: "antialiased",
        zIndex: 10,
        pointerEvents: "auto",
        display: "flex",
        flexDirection: "column",
        gap: rem(10), 
        maxHeight: "85vh", 
      }}
    >
      <TextInput
        placeholder={placeholderText}
        value={search}
        onChange={(e) => setSearch(e.currentTarget.value)}
        leftSection={<FontAwesomeIcon icon={faSearch} size="sm" color="rgba(255,255,255,0.5)" />}
        styles={{
          input: {
            backgroundColor: "rgba(25, 25, 25, 0.95)", 
            border: "1px solid rgba(255, 255, 255, 0.05)",
            color: "white",
            fontWeight: 500,
            fontSize: rem(14),
            borderRadius: rem(12), 
            height: rem(40), 
            textTransform: "none",
            boxShadow: "0 4px 10px rgba(0,0,0,0.4)",
            paddingLeft: rem(35),
            outline: "1px solid transparent",
            backfaceVisibility: "hidden"
          }
        }}
      />

      <Group wrap="nowrap" gap={rem(4)} justify="space-between">
        {categories.map((cat) => {
          const isSelected = selectedCategory === cat;
          return (
            <Box
              key={cat}
              onClick={() => onSelectCategory(isSelected ? null : cat)}
              style={{ 
                backgroundColor: isSelected ? THEME.blue : "rgba(25, 25, 25, 0.95)",
                border: isSelected ? `1px solid rgba(255,255,255,0.3)` : "1px solid rgba(255,255,255,0.05)",
                borderRadius: rem(10), 
                height: rem(38),
                flex: 1, 
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                transition: "all 0.15s ease",
                boxShadow: isSelected ? `0 0 10px ${THEME.blue}60` : "0 2px 4px rgba(0,0,0,0.4)",
                outline: "1px solid transparent", 
                backfaceVisibility: "hidden",
              }}
            >
              <CategoryIcon category={cat} isSelected={isSelected} />
            </Box>
          );
        })}
      </Group>

      <ScrollArea 
        h="60vh" 
        type="scroll" 
        w="100%" 
        scrollbarSize={0} 
        styles={{ 
            scrollbar: { display: 'none', width: 0, height: 0, opacity: 0 }, 
            corner: { display: 'none' },
            viewport: { paddingRight: 0 } 
        }}
      >
        <Stack gap={rem(10)} w="100%">
          {vehicles.map((v) => {
            const isSelected = selectedVehicle?.model === v.model;
            return (
              <Box
                key={v.model}
                onClick={() => onPreview(v)}
                w="100%" 
                style={{
                  padding: `${rem(10)} ${rem(14)}`, 
                  backgroundColor: isSelected ? THEME.blue : "rgba(25, 25, 25, 0.95)", 
                  borderRadius: rem(12), 
                  border: isSelected ? "1px solid rgba(255, 255, 255, 0.2)" : "1px solid rgba(255, 255, 255, 0.05)",
                  cursor: "pointer",
                  transition: "all 0.15s ease",
                  position: "relative",
                  zIndex: isSelected ? 2 : 1,
                  boxShadow: isSelected ? `0 4px 15px ${THEME.blue}60` : "0 4px 10px rgba(0,0,0,0.4)",
                  outline: "1px solid transparent",
                  backfaceVisibility: "hidden",
                  transform: "translateZ(0)", 
                  minHeight: rem(60), 
                }}
              >
                <Group wrap="nowrap" gap={rem(12)} w="100%" align="center">
                  <Box style={{ width: rem(60), display: 'flex', justifyContent: 'center' }}>
                    <Image 
                      src={v.image} 
                      w="100%" 
                      mah={rem(45)} 
                      fit="contain"
                      fallbackSrc="https://placehold.co/60x40?text=NO+IMG" 
                      style={{ 
                        filter: isSelected ? "drop-shadow(0 2px 4px rgba(0,0,0,0.3))" : "drop-shadow(0 4px 8px rgba(0,0,0,0.5))"
                      }} 
                    />
                  </Box>

                  <Stack gap={0} style={{ flex: 1, minWidth: 0 }}>
                    <Text 
                      c="white" 
                      fw={900} 
                      fz={rem(14)} 
                      tt="uppercase" 
                      truncate 
                      style={{ 
                        letterSpacing: "0.5px", 
                        fontFamily: "-apple-system, BlinkMacSystemFont, 'SF Pro Text', sans-serif",
                        textShadow: isSelected ? "none" : "0 1px 3px rgba(0,0,0,0.8)"
                      }}
                    >
                      {v.name}
                    </Text>
                    <Text 
                      c={isSelected ? "rgba(255,255,255,0.8)" : THEME.blue} 
                      fw={800} 
                      fz={rem(12)}
                    >
                      ${v.price.toLocaleString('en-US')}
                    </Text>
                  </Stack>
                </Group>
              </Box>
            );
          })}
        </Stack>
      </ScrollArea>
    </Box>
  );
};
import { Box, Stack, Group, ColorSwatch, rem, Text, Button } from "@mantine/core";
import { useEffect, useState } from "react";

const THEME = {
  blue: "#228be6", 
};

const DEFAULT_PALETTE = [
  "#ffffff", "#030303", "#dadada", "#c9ff07",
  "#9dff00", "#f43646", "#2196F3", "#ff2b83",
  "#ffae00", "#3F51B5"
];

interface Props {
  selectedColor: string; 
  onSetColor: (color: string) => void;
  disabled: boolean;
  locales: any;
  swatches?: string[]; 
  onTestDrive: () => void;
  onOpenPayment: () => void;
}

export const ActionSidebar = ({ selectedColor, onSetColor, disabled, locales, swatches, onTestDrive, onOpenPayment }: Props) => {
  const [stats, setStats] = useState({ speed: 0, acceleration: 0, braking: 0, handling: 0, storage: 0 });

  const activeSwatches = swatches && swatches.length > 0 ? swatches : DEFAULT_PALETTE;

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      if (event.data.action === "updateVehicleStats") {
        setStats(event.data.data);
      }
    };
    window.addEventListener("message", handleMessage);
    return () => window.removeEventListener("message", handleMessage);
  }, []);

  const StatBar = ({ label, value }: { label: string; value: number }) => {
    const filled = Math.max(1, Math.round((value / 100) * 5)); 
    return (
      <Stack gap={rem(4)} mb={rem(15)}>
        <Text 
          c="white" 
          fw={700} 
          fz={rem(16)} 
          style={{ letterSpacing: "0.5px", textShadow: "0 2px 4px rgba(0,0,0,0.8)", fontFamily: "-apple-system, BlinkMacSystemFont, 'SF Pro Text', sans-serif" }} 
        >
          {label}
        </Text>
        
        <Group 
          gap={rem(4)} 
          wrap="nowrap"
          style={{
            backgroundColor: "rgba(15, 15, 15, 0.8)", 
            border: "1px solid rgba(255, 255, 255, 0.1)", 
            padding: rem(4), 
            borderRadius: rem(6), 
            width: "fit-content",
            boxShadow: "0 4px 10px rgba(0,0,0,0.4)"
          }}
        >
          {[1, 2, 3, 4, 5].map((i) => (
            <Box
              key={i}
              style={{
                width: rem(38),
                height: rem(14),
                borderRadius: rem(3), 
                backgroundColor: i <= filled ? THEME.blue : "rgba(45, 45, 45, 0.5)",
              }}
            />
          ))}
        </Group>
      </Stack>
    );
  };

  return (
    <Box
      pos="absolute"
      left={rem(40)} 
      top="50%" 
      style={{
        transform: "translateY(-50%) perspective(1200px) rotateY(15deg)",
        transformOrigin: "left center",
        zIndex: 10,
        pointerEvents: disabled ? "none" : "auto",
        visibility: disabled ? "hidden" : "visible",
        opacity: disabled ? 0 : 1,
        transition: "opacity 0.3s ease",
        background: "transparent",
        display: "flex",
        flexDirection: "row",
      }}
    >
      <Stack gap={0} justify="center">
        <StatBar label={locales.top_speed || "Top Speed"} value={stats.speed} />
        <StatBar label={locales.acceleration || "Acceleration"} value={stats.acceleration} />
        <StatBar label={locales.braking || "Braking"} value={stats.braking} />
        <StatBar label={locales.handling || "Handling"} value={stats.handling} />

        <Box mt={rem(10)} mb={rem(25)}>
          <Text 
            c="white" 
            fz={rem(13)} 
            fw={500} 
            lh={1.4} 
            style={{ 
              textShadow: "0 1px 3px rgba(0,0,0,0.9)", 
              maxWidth: rem(300),
              fontFamily: "-apple-system, BlinkMacSystemFont, 'SF Pro Text', sans-serif"
            }}
          >
            You can have your car painted and make other aesthetic modifications at a workshop.

          </Text>
        </Box>

        <Text 
          c="white" 
          fw={700} 
          fz={rem(16)} 
          mb={rem(15)} 
          style={{ letterSpacing: "0.5px", textShadow: "0 2px 4px rgba(0,0,0,0.8)", fontFamily: "-apple-system, BlinkMacSystemFont, 'SF Pro Text', sans-serif" }}
        >
          {locales.vehicle_color || "Scegli un colore"}
        </Text>
        
        <Group gap={rem(12)} w={rem(260)}>
          {activeSwatches.map((hex, i) => {
            const isSelected = hex === selectedColor;
            return (
              <ColorSwatch
                key={i}
                component="button"
                color={hex}
                onClick={() => onSetColor(hex)}
                size={rem(40)}
                radius="xl"
                style={{ 
                  cursor: "pointer",
                  border: "3px solid white",
                  boxShadow: isSelected ? `0 0 15px ${hex}` : "0 4px 10px rgba(0,0,0,0.5)",
                  transform: isSelected ? "scale(1.1)" : "scale(1)",
                  transition: "all 0.15s ease",
                }}
              />
            );
          })}
        </Group>

        <Group gap={rem(10)} mt={rem(30)} w={rem(260)} grow>
          <Button 
            onClick={onTestDrive}
            bg="#1a1a1a" 
            c="white" 
            size="xs" 
            fw={900} 
            style={{ borderRadius: rem(12), boxShadow: "0 4px 10px #1a1a1ae8", textTransform: "uppercase" }}
          >
            {locales.test_drive || "TEST DRIVE"}
          </Button>
          <Button 
            onClick={onOpenPayment}
            bg={THEME.blue} 
            c="white" 
            size="xs" 
            fw={900} 
            style={{borderRadius: rem(12), boxShadow: `0 4px 10px ${THEME.blue}60`, textTransform: "uppercase" }}
          >
            {locales.purchase || "BUY"}
          </Button>
        </Group>
      </Stack>
    </Box>
  );
};
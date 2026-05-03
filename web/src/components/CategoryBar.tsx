import { Group, Box, Text, rem } from "@mantine/core";

interface Props {
  categories: string[];
  selectedCategory: string | null;
  onSelectCategory: (cat: string | null) => void;
}

export const CategoryBar = ({ categories, selectedCategory, onSelectCategory }: Props) => (
  <Group justify="flex-start" gap="xs">
    {categories.map((cat) => (
      <Box
        key={cat}
        onClick={() => onSelectCategory(selectedCategory === cat ? null : cat)}
        style={{
          backgroundColor: selectedCategory === cat ? "white" : "#0c0c0c",
          borderRadius: rem(10),
          height: rem(40),
          padding: `0 ${rem(20)}`,
          cursor: "pointer",
          transition: "transform 0.15s ease, background-color 0.2s ease",
          border: "1px solid rgba(255,255,255,0.15)",
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          userSelect: 'none'
        }}
        onMouseEnter={(e) => (e.currentTarget.style.transform = "scale(0.95)")}
        onMouseLeave={(e) => (e.currentTarget.style.transform = "scale(1)")}
        onMouseDown={(e) => (e.currentTarget.style.transform = "scale(0.90)")}
        onMouseUp={(e) => (e.currentTarget.style.transform = "scale(0.95)")}
      >
        <Text 
          fw={800} 
          fz={rem(13)} 
          c={selectedCategory === cat ? "black" : "white"}
          tt="uppercase"
        >
          {cat}
        </Text>
      </Box>
    ))}
  </Group>
);
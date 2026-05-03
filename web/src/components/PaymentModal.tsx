import { Modal, Stack, Group, Title, Text, Box, rem } from "@mantine/core";

interface Props {
  opened: boolean;
  onClose: () => void;
  vehicle: any | null;
  onPurchase: (method: "money" | "bank") => void;
  locales: any;
}

export const PaymentModal = ({ opened, onClose, vehicle, onPurchase, locales }: Props) => {

  const getButtonStyle = (isBank: boolean) => ({
    height: rem(50),
    borderRadius: rem(12),
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    cursor: "pointer",
    transition: "transform 0.15s ease, filter 0.2s ease",
    background: isBank 
      ? "linear-gradient(135deg, #b2f252, #8bc34a)" 
      : "linear-gradient(135deg, #00aaff, #0077ff)",
    flex: 1,
    boxShadow: isBank ? "0 4px 15px rgba(178, 242, 82, 0.2)" : "0 4px 15px rgba(0, 170, 255, 0.2)"
  });

  const handleMouseEnter = (e: React.MouseEvent<HTMLDivElement>) => {
    e.currentTarget.style.transform = "scale(1.05)";
  };

  const handleMouseLeave = (e: React.MouseEvent<HTMLDivElement>) => {
    e.currentTarget.style.transform = "scale(1)";
  };

  const handleMouseDown = (e: React.MouseEvent<HTMLDivElement>) => {
    e.currentTarget.style.transform = "scale(0.95)";
  };

  return (
    <Modal
      opened={opened}
      onClose={onClose}
      centered
      size="sm"
      withCloseButton={false}
      styles={{
        content: { 
          background: "rgba(25, 25, 25, 0.95)",
          borderRadius: rem(12), 
          border: "none",
          boxShadow: "0 25px 50px rgba(0,0,0,0.8)"
        },
        body: {
            padding: rem(20)
        }
      }}
    >
      <Stack gap="xl" align="center">

        <Stack gap={4} align="center">
          <Title order={2} c="white" fw={900} ta="center" style={{ letterSpacing: "-0.5px" }}>
            {locales.purchase_title}
          </Title>
          <Text size="sm" c="gray.5" ta="center" fw={600} tt="uppercase" style={{ letterSpacing: "1px" }}>
            {locales.irreversible_action}
          </Text>
        </Stack>

        <Stack align="center" gap={2}>
          <Text c="white" fw={800} tt="uppercase" fz={rem(18)} style={{ opacity: 0.7 }}>
            {vehicle?.name}
          </Text>
          <Text fz={rem(36)} fw={900} c="#228be6" >
            ${vehicle?.price?.toLocaleString()}
          </Text>
        </Stack>

        <Group grow mt="lg" w="100%" gap="md">
          <Box
            onClick={() => onPurchase("money")}
            style={getButtonStyle(false)}
            onMouseEnter={handleMouseEnter}
            onMouseLeave={handleMouseLeave}
            onMouseDown={handleMouseDown}
            onMouseUp={handleMouseEnter}
          >
            <Text fw={900} c="white" fz={rem(15)} tt="uppercase">{locales.cash}</Text>
          </Box>
          <Box
            onClick={() => onPurchase("bank")}
            style={getButtonStyle(true)}
            onMouseEnter={handleMouseEnter}
            onMouseLeave={handleMouseLeave}
            onMouseDown={handleMouseDown}
            onMouseUp={handleMouseEnter}
          >
            <Text fw={900} c="black" fz={rem(15)} tt="uppercase">{locales.bank}</Text>
          </Box>
        </Group>
      </Stack>
    </Modal>
  );
};
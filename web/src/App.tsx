import { useEffect, useState } from "react";
import Showroom from "./components/Showroom";
import { useNuiEvent } from "./hooks/useNuiEvent";
import { fetchNui } from "./utils/fetchNui";
import { isEnvBrowser } from "./utils/misc";
import { Box, Group, Title, rem } from "@mantine/core";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faStopwatch } from "@fortawesome/free-solid-svg-icons";

const App: React.FC = () => {
  const [showroomVisible, setShowroomVisible] = useState(false);
  const [testDriveActive, setTestDriveActive] = useState(false);
  const [testDriveSeconds, setTestDriveSeconds] = useState<number | null>(null);

  useNuiEvent<boolean>("setShowroomVisible", (data) => {
    setShowroomVisible(data);
  });

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      const { action, data } = event.data || {};

      if (action === "testDrive:start") {
        setTestDriveActive(true);
        setTestDriveSeconds(Math.ceil(data?.duration / 1000) || 0);
      }

      if (action === "testDrive:update") {
        setTestDriveSeconds(data);
      }

      if (action === "testDrive:end") {
        setTestDriveActive(false);
        setTestDriveSeconds(null);
      }
    };

    window.addEventListener("message", handleMessage);
    return () => window.removeEventListener("message", handleMessage);
  }, []);

  useEffect(() => {
    if (!showroomVisible) return;

    const keyHandler = (e: KeyboardEvent) => {
      if (["Escape"].includes(e.code)) {
        if (!isEnvBrowser()) fetchNui("hide-ui");
        setShowroomVisible(false);
      }
    };
    window.addEventListener("keydown", keyHandler);
    return () => window.removeEventListener("keydown", keyHandler);
  }, [showroomVisible]);

  return (
    <>
      {showroomVisible && <Showroom />}

      {testDriveActive && (
        <Box
          pos="absolute"
          top={0}
          left={0}
          right={0}
          bottom={0}
          style={{ zIndex: 9999, pointerEvents: "none" }}
        >
          <Group
            justify="center"
            align="center"
            style={{ height: "100%", flexDirection: "column" }}
          >
            <Group align="center" gap="sm">
              <FontAwesomeIcon icon={faStopwatch} color="white" style={{ fontSize: rem(28) }} />
              <Title
                order={1}
                c="white"
                style={{ fontSize: rem(36), margin: 0 }}
              >
                {testDriveSeconds ?? 0}s
              </Title>
            </Group>
          </Group>
        </Box>
      )}
    </>
  );
};

export default App;

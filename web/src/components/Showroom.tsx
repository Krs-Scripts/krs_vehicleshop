import { Box} from "@mantine/core";
import { useMemo, useState, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { VehicleBrowser } from "./VehicleSidebar"; 
import { ActionSidebar } from "./ActionSidebar";
import { PaymentModal } from "./PaymentModal";

type NuiVehicle = { model: string; name: string; price: number; category: string; image?: string; };

export default function Showroom() {
  const [vehicles, setVehicles] = useState<NuiVehicle[]>([]);
  const [search, setSearch] = useState("");
  const [selectedVehicle, setSelectedVehicle] = useState<NuiVehicle | null>(null);
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [selectedColor, setSelectedColor] = useState<string>("#FFFFFF"); 
  const [openPayment, setOpenPayment] = useState(false);
  const [locales, setLocales] = useState<any>({});
  const [swatches, setSwatches] = useState<string[]>([]); 

    useEffect(() => {
    (async () => {
        const initData = await fetchNui<any>("getShowroomData");
        if (initData) {
            setVehicles(initData.vehicles || []);
            setLocales(initData.locales || {});
            setSwatches(initData.swatches || []);
        }
    })();
  }, []);

  const categories = useMemo(() => [...new Set(vehicles.map((v) => v.category))].sort(), [vehicles]);

  const filteredVehicles = useMemo(() => {
    const s = search.toLowerCase();
    return vehicles.filter((v) => {
      const matchSearch = v.name.toLowerCase().includes(s) || v.model.toLowerCase().includes(s);
      const matchCat = selectedCategory ? v.category === selectedCategory : true;
      return matchSearch && matchCat;
    });
  }, [vehicles, search, selectedCategory]);

  const handleColorChange = async (color: string) => {
    setSelectedColor(color);
    await fetchNui("setPreviewColor", { color }); 
  };

  const handlePreview = async (v: NuiVehicle) => {
    setSelectedVehicle(v);
    await fetchNui("showroom:preview", { model: v.model });
    await fetchNui("setPreviewColor", { color: selectedColor });
  };

  const handlePurchase = async (method: "money" | "bank") => {
    if (!selectedVehicle) return;
    setOpenPayment(false);
    await fetchNui("showroom:purchase", {
      model: selectedVehicle.model,
      color: selectedColor, 
      price: selectedVehicle.price,
      method,
    });
    setSelectedVehicle(null);
  };

  const handleNext = () => {
    if (!selectedVehicle || filteredVehicles.length === 0) return;
    const currentIndex = filteredVehicles.findIndex(v => v.model === selectedVehicle.model);
    const nextIndex = (currentIndex + 1) % filteredVehicles.length;
    handlePreview(filteredVehicles[nextIndex]);
  };

  const handlePrev = () => {
    if (!selectedVehicle || filteredVehicles.length === 0) return;
    const currentIndex = filteredVehicles.findIndex(v => v.model === selectedVehicle.model);
    const prevIndex = (currentIndex - 1 + filteredVehicles.length) % filteredVehicles.length;
    handlePreview(filteredVehicles[prevIndex]);
  };

  if (!locales.vehicle) return null;

  return (
    <Box pos="absolute" inset={0} style={{ overflow: "hidden", fontFamily: "'Bebas Neue', 'Oswald', sans-serif" }}>
      
      <ActionSidebar
        selectedColor={selectedColor}
        onSetColor={handleColorChange}
        disabled={!selectedVehicle}
        locales={locales}
        swatches={swatches}
        onTestDrive={() => fetchNui("showroom:testDrive", { model: selectedVehicle?.model, color: selectedColor })}
        onOpenPayment={() => setOpenPayment(true)}
      />

      <VehicleBrowser
        vehicles={filteredVehicles}
        categories={categories}         
        search={search}
        setSearch={setSearch}
        selectedCategory={selectedCategory} 
        onSelectCategory={setSelectedCategory} 
        selectedVehicle={selectedVehicle}
        onPreview={handlePreview}
        placeholderText={locales.search_placeholder || "Search..."}
      />
    

      <PaymentModal
        opened={openPayment}
        onClose={() => setOpenPayment(false)}
        vehicle={selectedVehicle}
        onPurchase={handlePurchase}
        locales={locales}
      />
    </Box>
  );
}
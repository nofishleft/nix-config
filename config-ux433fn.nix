{ ... }:

{
  config = {
    hostName = "zenbook";
    useNvidiaGpu = true;
    nvidiaBusIds = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
    gaming = false;
  };
}

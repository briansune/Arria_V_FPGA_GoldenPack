The steps for installing the driver to run the Altera PCI Express Performance Demo are as follows.
	1. Open Device Manager
	2. Under "Other Devices," find a device called "PCI Device." If there are multiple devices with that name, find the "PCI Device" with Vendor ID = 1172 (Altera Corporation)
		a. Right click "PCI Device"
		b. Go to the "Details" tab
		c. Select the "Hardware Ids" property
		d. Repeat with another "PCI Device" if the Vendor ID is not 1172
	3. Right click "PCI Device," and choose "Update Driver Software..."
	4. Choose "Browse my computer for driver software"
	5. Browse to C:\...\Drivers\64-bit or 32-bit depending on your operating system
	6. Choose "Next"
	7. Choose "Install this driver anyway" if you get "Windows cannot verify the publisher of this driver software"
	8. Launch the altpcie_demo GUI

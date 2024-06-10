# Syringe Pump Connection Instructions

In order to set up the connection to your syringe pumps, follow the instructions below.

## Required Equipment

To complete this setup, you will need the following equipment:
- 2 NE-501 syringe pumps and power cables
- RS232 to Ethernet adapter (we used PUSR USR-TCP232-302) and power cable
- USB Ethernet adapter
- Ethernet cable
- Null modem adapter

PROVIDE LINK^^^

- 1 RS-232 pump network cable (must use cable that comes with pump)
- 1 RJ11 cable (must use cable that comes with pump)

## Setup

1. **Powering the Pumps**:
   - Connect each NE-501 syringe pump to its power cable, plug them into a power outlet and flip the back power switch.
2. **Connecting the Pumps**:
   - Use the RS-232 pump network cable to connect the first pump to the RS232 to Ethernet converter with the null modem converter.
   - Connect the RS232 to ethernet adapter to power source.
   - Connect to RS232 to ethernet adapter to USB ethernet adapter using ethernet cable in LAN port.
   - Connect the USB ethernet adapter to computer USB port.
   - Use the phone line style cable to connect the second pump to the first pump. This creates a network between the two pumps. Cable should go in "to network" port of first pump and "to computer" port of second pump.

3. **Setting Up the RS232 to Ethernet Converter**:
   - USR-TCP232-302 User Manual: https://www.pusr.com/uploads/20231030/84525756916a59f9529f423b053cb2d4.pdf
   - Follow the setup instructions. Configure the converter using the provided programs (Windows) or through the web interface (Windows or Mac) covered in section 3.1
   - Configure the converter to TCP Server Mode
   - To ensure you are transmitting and recieving messages correctly, you can download their test program convered in section 2.2.4 (Windows)
   
   -TODO: Talk about how to add an IP to mac
   
    **IMPORTANT**
   Don't forget to use the null modem adapter for this specific converter. Without it, you will be able to establish a connection with the syringe pump, but you won't be able to send or receive any messages
   
4. **Connecting to the pumps via Fifi**
   - Open the Fifi app, then open the settings by navigating to Fifi->Settings at the top left
   - Configure the IP Address and port configured in step 3 above
   - Click on the syringe pump at the top right of the screen; it should turn green to show the pumps are connected
   

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_api_templates/controller/api_provider.dart'; 
import 'package:provider/provider.dart' show Consumer;

class AddNewDeviceScreen extends StatefulWidget {
  // final Data productData; // existing product data
  //
  // const AddLicenseSoftwareScreen({Key? key, required this.productData})
  //     : super(key: key);

  @override
  State<AddNewDeviceScreen> createState() => _AddNewDeviceScreenState();
}

class _AddNewDeviceScreenState extends State<AddNewDeviceScreen> {

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController deviceIdController = TextEditingController();
  final TextEditingController iPAddressController = TextEditingController();
  final TextEditingController macAddressController = TextEditingController();
  final TextEditingController installedLocationController = TextEditingController();
  final TextEditingController vendorAMCPartnerController = TextEditingController();
  final TextEditingController configurationDetailsController = TextEditingController();
  final TextEditingController maintenanceHistoryController = TextEditingController();
  final TextEditingController nextServiceDueDateController = TextEditingController();

  DateTime? _nextServiceDueDateDate;
  String? selectedDeviceType;


  // Dropdown options
  final List<String> deviceTypesList = [
    'Switch',
    'Router',
    'Firewall',
    'Access Point',
    'CCTV',
    'Server',
  ];

  @override
  void initState() {
    super.initState();
    // _initializeFormFields();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller, Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text =
        "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
        onDateSelected(picked);
      });
    }
  }

  void _submitForm(ApiProvider provider) {
    if (_formKey.currentState?.validate() ?? false) {
      final body = {
        "deviceId": deviceIdController.text,
        "deviceType": selectedDeviceType,
        "ipAddress": iPAddressController.text,
        "macAddress": macAddressController.text,
        "installedLocation": installedLocationController.text,
        "vendor": vendorAMCPartnerController.text,
        "nextServiceDue": _nextServiceDueDateDate!.toIso8601String().split('T')[0], // YYYY-MM-DD format
        "configurationDetails": configurationDetailsController.text,
        "maintenanceHistory": maintenanceHistoryController.text,
      };

      provider.addTechNewDevice(context, body);
    }

  }


  @override
  void dispose() {
    deviceIdController.dispose();
    iPAddressController.dispose();
    macAddressController.dispose();
    installedLocationController.dispose();
    vendorAMCPartnerController.dispose();
    configurationDetailsController.dispose();
    maintenanceHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      backgroundColor: Colors.grey[50],
    appBar: AppBar(
      title: Text("List"),
    ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24.0 : 0.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(isTablet ? 32.0 : 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asset Information',
                  style: TextStyle(
                    fontSize: isTablet ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill in the details to add a new device to the system',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: isTablet ? 32 : 24),

                // First Row
                _buildResponsiveRow(
                  isTablet: isTablet,
                  isDesktop: isDesktop,
                  children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: TextField(
                          controller: deviceIdController,
                          decoration: InputDecoration(
                            labelText: "Device Id",
                            hintText: "Enter Device Id",
                            prefixIcon: Icon(Icons.person_pin),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),

                      DropdownButtonFormField<String>(
                        value: selectedDeviceType,
                        items: deviceTypesList.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDeviceType = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Asset Type *",          // acts like your `label`
                          hintText: "Select Asset Type",      // acts like your `hint`
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      )



                  ],
                ),

                Consumer<ApiProvider>(
                  builder: (context, addAssetProvider, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // button color
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: addAssetProvider.isLoading
                          ? null // disables button when loading
                          : () {
                        _submitForm(addAssetProvider);
                      },
                      child: Text(
                        addAssetProvider.isLoading ? "Adding..." : "Add Device",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveRow({
    required bool isTablet,
    required bool isDesktop,
    required List<Widget> children,
  }) {
    if (isDesktop) {
      // Desktop: 3 columns
      return Row(
        children: children
            .map((child) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: child,
          ),
        ))
            .toList(),
      );
    } else if (isTablet) {
      // Tablet: 2 columns
      return Column(
        children: [
          Row(
            children: children
                .take(2)
                .map((child) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: child,
              ),
            ))
                .toList(),
          ),
          if (children.length > 2) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: children[2],
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ],
      );
    } else {
      // Mobile: 1 column
      return Column(
        children: children
            .map((child) => Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: child,
        ))
            .toList(),
      );
    }
  }

}


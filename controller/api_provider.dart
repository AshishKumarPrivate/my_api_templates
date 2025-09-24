import 'package:flutter/material.dart';
import '../../../../network_manager/api_response.dart';
import '../model/single_message_model.dart';
import '../model/tech_add_new_devices_model.dart';
import '../model/tech_all_devices_list_model.dart';
import '../model/tech_update_devices_model.dart';
import '../model/vendor_categories_list_model.dart';
import '../network_manager/repository.dart';
import '../utils/storage_util.dart';

class ApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ApiResponse<TechAllDevicesListModelResponse>? _getAllTechDeviceListModelResponse;
  ApiResponse<TechAllDevicesListModelResponse>? get getAllTechDeviceListModelResponse => _getAllTechDeviceListModelResponse;

  ApiResponse<TechAddNewDeviceModelResponse>? _addTechNewDeviceModelResponse;
  ApiResponse<TechAddNewDeviceModelResponse>?get addTechNewDeviceModelResponse => _addTechNewDeviceModelResponse;

  ApiResponse<TechUpdateDeviceModelResponse>? _updateTechDeviceModelResponse;
  ApiResponse<TechUpdateDeviceModelResponse>? get updateTechDeviceModelResponse => _updateTechDeviceModelResponse;

  ApiResponse<SingleMessageModelResponse>? _deleteTechDeviceModelResponse;
  ApiResponse<SingleMessageModelResponse>? get deleteTechDeviceModelResponse => _deleteTechDeviceModelResponse;


  ApiResponse<VendorCategoryListModelResponse>? _getAllVenodorCategoryListModelResponse;
  ApiResponse<VendorCategoryListModelResponse>? get getVendorCategoryListModelResponse => _getAllVenodorCategoryListModelResponse;


  /////////////////////////// NETWORK AND INFRASTRUCTURE /////////////////////////

  Future<void> getAllTechDeviceList(
    BuildContext context,
    int page,
    int limit,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'limit': limit,
      };
      final response = await _repository.getAllTechDevicesList(queryParameters);
      _getAllTechDeviceListModelResponse = response;
      if (!response.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Success")));
      }
    } catch (e) {
      _getAllTechDeviceListModelResponse = ApiResponse.error(
        "Something went wrong: $e",
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> addTechNewDevice(
    BuildContext context,
    Map<String, dynamic> body,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _repository.addNewTechDevice(body);
      _addTechNewDeviceModelResponse = response;

      if (response.success && response.data != null) {
        // final message = response.data!.message!.isNotEmpty == true ? response.data!.message!  : "Assets Added Successfully!";
        final apiMessage = response.data?.message;
        final message = (apiMessage != null && apiMessage.trim().isNotEmpty)
            ? apiMessage
            : "Device Added Successfully!";
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(apiMessage.toString())));
        // StorageHelper().setLoginRole("$role");
        // final roles = await StorageHelper().getLoginRole();
        Navigator.pop(context);

      } else {
        debugPrint("Device Added failed: ${response.message}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed")));
      }
    } catch (e, stackTrace) {
      debugPrint("Device Added Exception: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTechDevice(
    BuildContext context,
    Map<String, dynamic> body,
    String licenceSoftwareId,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _repository.updateTechDevice(
        body,
        licenceSoftwareId,
      );
      _updateTechDeviceModelResponse = response;

      if (response.success && response.data != null) {
        // final message = response.data!.message!.isNotEmpty == true ? response.data!.message!  : "License Updated Successfully!";
        final apiMessage = response.data?.message;
        final message = (apiMessage != null && apiMessage.trim().isNotEmpty)
            ? apiMessage
            : "Device Updated Successfully!";

        Navigator.pop(context, true); // Pass true as result
      } else {
        debugPrint("Device Updated failed: ${response.message}");
        Navigator.pop(context, false);

      }
    } catch (e, stackTrace) {
      debugPrint("Device Updated Exception: $e");
      Navigator.pop(context, false);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTechDeviceWithoutNavigation(
    BuildContext context,
    String lilcenceId,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _repository.deleteTechDevice(lilcenceId);
      _deleteTechDeviceModelResponse = response;

      if (!response.success) {
        debugPrint("Device Delete failed: ${response.message}");
      }
    } catch (e, stackTrace) {
      debugPrint("Device Delete Exception: $e");
      _deleteTechDeviceModelResponse = ApiResponse.error(
        "Something went wrong: $e",
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllVendorCategoryList(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {

      final response = await _repository.getAllVendorCategoryList();
      _getAllVenodorCategoryListModelResponse = response;
      if (!response.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Success")));
      }
    } catch (e) {
      _getAllVenodorCategoryListModelResponse = ApiResponse.error("Something went wrong: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

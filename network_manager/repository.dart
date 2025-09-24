
import 'package:flutter/cupertino.dart';

import '../model/login_model.dart';
import '../model/single_message_model.dart';
import '../model/tech_add_new_devices_model.dart';
import '../model/tech_all_devices_list_model.dart';
import '../model/tech_update_devices_model.dart';
import '../model/vendor_categories_list_model.dart';
import '../utils/storage_util.dart';
import 'api_response.dart';
import 'dio_helper.dart';

class Repository {
  final DioHelper _dioHelper = DioHelper();

  static const String baseURL = 'https://dss-backend-qnvh.onrender.com/api/v1';


  Future<ApiResponse<LoginResponseModel>> loginUser(
      Map<String, dynamic> requestBody,) async {
    final String url = "$baseURL/login/email/password";

    try {
      final response = await _dioHelper.post<Map<String, dynamic>>(
        url: url,
        requestBody: requestBody,
        // isAuthRequired: false,
      );
      if (response.success && response.data != null) {
        return ApiResponse.success(LoginResponseModel.fromJson(response.data!));
      } else {
        return ApiResponse.error(
          response.message ?? "Unknown error",
          statusCode: response.statusCode,
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse.error("Login failed: ${e.toString()}");
    }
  }

  Future<ApiResponse<TechAllDevicesListModelResponse>> getAllTechDevicesList(
      Map<String, dynamic> queryParameters) async {
    final String url = "$baseURL/tech/network-infrastructure/get";
    // final String url = "$baseUrl/api/v1/sales/all/employee";

    try {
      final response = await _dioHelper.get<Map<String, dynamic>>(
          url: url, queryParams: queryParameters);
      if (response.success && response.data != null) {
        return ApiResponse.success(
          TechAllDevicesListModelResponse.fromJson(response.data!),
        );
      } else {
        return ApiResponse.error(
          response.message ?? "Unknown error",
          statusCode: response.statusCode,
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse.error("Get All assets failed: ${e.toString()}");
    }
  }

  Future<ApiResponse<TechAddNewDeviceModelResponse>> addNewTechDevice(
      Map<String, dynamic> requestBody) async {
    // final String url = "$baseUrl/api/v1/sales/tl-report/create/${salesTlId}";
    final String url = "$baseURL/tech/network-infrastructure/add";


    try {
      final response = await _dioHelper.post<Map<String, dynamic>>(
        url: url,
        requestBody: requestBody,
        // isAuthRequired: false,
      );
      if (response.success && response.data != null) {
        return ApiResponse.success(
          TechAddNewDeviceModelResponse.fromJson(response.data!),
        );
      } else {
        return ApiResponse.error(
          response.message ?? "Unknown error",
          statusCode: response.statusCode,
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse.error("Add assets failed: ${e.toString()}");
    }
  }

  Future<ApiResponse<TechUpdateDeviceModelResponse>> updateTechDevice(
      Map<String, dynamic> requestBody,
      String networkDevicesID) async {
    // final String url = "$baseUrl/api/v1/sales/tl-report/create/${salesTlId}";
    final String url = "$baseURL/tech/network-infrastructure/update/${networkDevicesID}";


    try {
      final response = await _dioHelper.put<Map<String, dynamic>>(
          url: url,
          requestBody: requestBody
      );
      if (response.success && response.data != null) {
        return ApiResponse.success(
          TechUpdateDeviceModelResponse.fromJson(response.data!),
        );
      } else {
        return ApiResponse.error(
          response.message ?? "Unknown error",
          statusCode: response.statusCode,
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse.error("Update assets failed: ${e.toString()}");
    }
  }

  Future<ApiResponse<SingleMessageModelResponse>> deleteTechDevice(
      String networkDevicesID) async {
    // final String url = "$baseUrl/api/v1/sales/tl-report/create/${salesTlId}";
    final String url = "$baseURL/tech/network-infrastructure/delete/${networkDevicesID}";


    try {
      final response = await _dioHelper.delete<Map<String, dynamic>>(
        url: url,
      );
      if (response.success && response.data != null) {
        return ApiResponse.success(
          SingleMessageModelResponse.fromJson(response.data!),
        );
      } else {
        return ApiResponse.error(
          response.message ?? "Unknown error",
          statusCode: response.statusCode,
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse.error("Delete assets failed: ${e.toString()}");
    }
  }

  Future<ApiResponse<
      VendorCategoryListModelResponse>> getAllVendorCategoryList() async {
    final String url = "$baseURL/vendor/get-categories";
    // final String url = "$baseUrl/api/v1/sales/all/employee";

    try {
      final response = await _dioHelper.get<Map<String, dynamic>>(url: url);
      if (response.success && response.data != null) {
        return ApiResponse.success(
          VendorCategoryListModelResponse.fromJson(response.data!),
        );
      } else {
        return ApiResponse.error(
          response.message ?? "Unknown error",
          statusCode: response.statusCode,
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse.error("Get All Leads failed: ${e.toString()}");
    }
  }


}
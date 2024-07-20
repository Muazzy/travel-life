import 'package:dio/dio.dart';
import 'package:starter_app/src/base/utils/constants.dart';
import 'package:starter_app/src/models/ors_models/get_geocode_response_model.dart';
import 'package:starter_app/src/models/osrm_models/osrm_route_response.dart';
import 'package:starter_app/src/services/remote/api_result.dart';
import 'package:starter_app/src/services/remote/network_exceptions.dart';
import 'package:starter_app/src/services/remote/ors/ors_api_client.dart';
import 'package:starter_app/src/services/remote/ors/orsm_api_client.dart';

class OrsService {
  OrsApiClient? _apiClient;
  OsrmApiClient? _osrmApiClient;

  OrsService() {
    _apiClient = OrsApiClient(Dio());
    _osrmApiClient = OsrmApiClient(Dio());
  }

  ///////////////////////////////////////GEOCODE////////////////////////////////////////////

  Future<ApiResult<GetGeocodeResponseModel>?> searchAutocomplete(
      String searchQuery) async {
    try {
      var response = await _apiClient?.getReq(
        "/geocode/autocomplete",
        queryParameters: {"text": searchQuery},
      );
      if (response!.statusCode != 200) {
        Constants.customWarningSnack(response.statusMessage.toString());
        return null;
      }
      print('check searchAutocomplete response ${response.data}');
      return ApiResult.success(
        data: GetGeocodeResponseModel.fromJson(response.data),
      );
    } catch (e) {
      Constants.customWarningSnack(
          NetworkExceptions.getDioExceptionMessage(e).toString());
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  //for exact search or can be used when the user presses enter, like can be used on 'onDone' function
  Future<ApiResult<GetGeocodeResponseModel>?> search(String searchQuery) async {
    try {
      var response = await _apiClient?.getReq(
        "/geocode/search",
        queryParameters: {"text": searchQuery},
      );
      if (response!.statusCode != 200) {
        Constants.customWarningSnack(response.statusMessage.toString());
        return null;
      }
      print('check search response ${response.data}');
      return ApiResult.success(
        data: GetGeocodeResponseModel.fromJson(response.data),
      );
    } catch (e) {
      Constants.customWarningSnack(
          NetworkExceptions.getDioExceptionMessage(e).toString());
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  //this will be used when we have got lat and lon by clicking on the map and we want some textual representation of it
  Future<ApiResult<GetGeocodeResponseModel>?> reverse(
      {required double lat, required double lon}) async {
    try {
      var response = await _apiClient?.getReq(
        "/geocode/reverse",
        queryParameters: {
          "point.lon": lon,
          "point.lat": lat,
          "size": 1, //to get only one result which is closest to the point
        },
      );
      if (response!.statusCode != 200) {
        Constants.customWarningSnack(response.statusMessage.toString());
        return null;
      }
      print('check reverse response ${response.data}');
      return ApiResult.success(
        data: GetGeocodeResponseModel.fromJson(response.data),
      );
    } catch (e) {
      Constants.customWarningSnack(
          NetworkExceptions.getDioExceptionMessage(e).toString());
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////DIRECTIONS//////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////OSRM/////////////////////////////////////////////

  Future<ApiResult<OsrmRouteResponse>?> osrmRoute({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) async {
    try {
      print('check osrmRoute coords1 ${lat1}, ${lon1}');
      print('check osrmRoute coords2 ${lat2}, ${lon2}');

      var response = await _osrmApiClient?.getReq(
        "/route/v1/driving/$lon1,$lat1;$lon2,$lat2",
        queryParameters: {
          "alternatives": true,
          "steps": true,
        },
      );
      if (response!.statusCode != 200) {
        Constants.customWarningSnack(response.statusMessage.toString());
        return null;
      }
      print('check osrmRoute response ${response.data}');
      return ApiResult.success(
        data: OsrmRouteResponse.fromJson(response.data),
      );
    } catch (e) {
      Constants.customWarningSnack(
          NetworkExceptions.getDioExceptionMessage(e).toString());
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }
}

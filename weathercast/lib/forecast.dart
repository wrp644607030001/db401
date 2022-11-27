import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'location.dart';
import 'weather.dart';

Future<Weather> forecast() async {
  const url = 'https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at';
  const token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjI4YTEyNWNmODJjMWI4ODRjZTFiMTZhYmQ3Mzk4OTU5YjM4YmQ3MjRlYjY4MjM1MTk0NDAxMGY4ODY4NzAyNTA5NGQ5NzBlODdjM2EzODU1In0.eyJhdWQiOiIyIiwianRpIjoiMjhhMTI1Y2Y4MmMxYjg4NGNlMWIxNmFiZDczOTg5NTliMzhiZDcyNGViNjgyMzUxOTQ0MDEwZjg4Njg3MDI1MDk0ZDk3MGU4N2MzYTM4NTUiLCJpYXQiOjE2Njg5MzM1MTIsIm5iZiI6MTY2ODkzMzUxMiwiZXhwIjoxNzAwNDY5NTEyLCJzdWIiOiIyMjcxIiwic2NvcGVzIjpbXX0.heCyX-vd3yfP8Nlhp0cSlAozxvqdKo_p8mBVg9aOA534R7jtQja2dG03wsb5fMJ8zLUdcz5tY5BCY9QOXbfkHGCs8nR_o88ntyxMvvlwntJ_CgNas7iloIp41z08MVGmO3U3Iighp2Hm0a7MJca8oBsJFupXrWRLtGyy_cbJnVo9iCI3nP1DY8FZEnY3seqj8zDOR4WMoWj2j2e06NxwW1RUzpegpq0QqPw_naePShQpcmi95eeiQtMfatoizo0YYPn4dbsUtBS51lF6UPGpneJ3luZo8TD1neApZLfHUylAmeiQ6f4NwlIVNSypLORP7XsjwmvP7_ULEOU-yO4-iaT8D61rLZ-HWHyTpRNLTSSakU4UHbRPdIG_1ZkoPnvdb9rdu8Qitm3CO3y8l48UdHmEL2aHCcfNqC-PMcmkhm7EhnuPualg1R8o-uFIoVGBSF-nA53Fccy32sRDXddNhX2PATkWC-461ROncvMPlxdp2M5TEA5NH4Ow5kaiusxdigpSOZfBzG4icTv7D_89YRUbW72GPA6ZwPT47SpDH6ouFDqEBPMi4zUIaOTcZP4o5Skgu4dvntWWOScav5b3YIDIQV2eK-NO038B60QvxPrQu1oQHIIvmfDPZkL5GfHc3TfzHEmg8BCMn80ZL1ZS4yk-jwQQ9lBdI-E0DngYo3c';

  try {
    Position location = await getCurrentLocation();
    http.Response response = await http.get(
    Uri.parse('$url?lat=${location.latitude}&lon=${location.longitude}&fields=tc,cond'), 
    headers: {
      'accept': 'application/json',
      'authorization': 'Bearer $token',
    }
    );
    if(response.statusCode == 200) {
      var result = jsonDecode(response.body)['WeatherForecasts'][0]['forecasts'][0]['data'];
      Placemark address = (await placemarkFromCoordinates(location.latitude, location.longitude)).first;
      return Weather(
        address: '${address.subLocality}\n${address.administrativeArea}',
        temperature: result['tc'],
        cond: result['cond'],
      );
    } else {
      return Future.error(response.statusCode);
    }
  } catch (e) {
    return Future.error(e);
  }
}

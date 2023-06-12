class HotelFormModel {
  final String checkIn, checkOut, nameLocation;
  final int rooms, adults, children, duration;
  final double latitude, longitude;
  final String minRate, maxRate;
  final double minCategory, maxCategory;
  final List<int> childrenAgeList;

  HotelFormModel({
    required this.checkIn,
    required this.checkOut,
    required this.rooms,
    required this.adults,
    required this.duration,
    required this.children,
    required this.latitude,
    required this.longitude,
    required this.maxRate,
    required this.minRate,
    required this.maxCategory,
    required this.minCategory,
    required this.nameLocation,
    required this.childrenAgeList,
  });

  Map<String, dynamic> get toJsonForm => <String, dynamic>{
        'stay': {
          'checkIn': checkIn,
          'checkOut': checkOut,
        },
        'occupancies': [
          {
            'rooms': rooms,
            'adults': adults,
            'children': children,
            'paxes': childrenAgeList
                .map(
                  (e) => {
                    'type': 'CH',
                    'age': e,
                  },
                )
                .toList(),
          },
        ],
        'geolocation': {
          'latitude': latitude,
          'longitude': longitude,
        },
        'filter': {
          'minRate': minRate,
          'maxRate': maxRate,
          'minCategory': minCategory,
          'maxCategory': maxCategory,
        }
      };
}

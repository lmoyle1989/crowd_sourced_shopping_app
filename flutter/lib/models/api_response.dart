class ApiResponse {
  String? storeName;
  String? storeAddress;
  double? averagePrice;
  double? matchRank;
  double? daysSinceUpload;

  ApiResponse({
    this.storeName,
    this.storeAddress,
    this.averagePrice,
    this.matchRank,
    this.daysSinceUpload,
  });

  factory ApiResponse.fromMap(Map<String, dynamic> parsedJSON) {
    return ApiResponse(
      storeName: parsedJSON['store_name'],
      storeAddress: parsedJSON['store_address'],
      averagePrice: parsedJSON['average_price'],
      matchRank: parsedJSON['match_rank'],
      daysSinceUpload: parsedJSON['days_since_upload'],
    );
  }
}
